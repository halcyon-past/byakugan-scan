import Foundation
import CoreGraphics
import Vision

/// Supported tabular export formats.
enum TableFormat: String, CaseIterable, Identifiable, Codable {
    case markdown = "markdown"
    case csv = "csv"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .markdown: return "Markdown Table (| Col 1 | Col 2 |)"
        case .csv: return "Comma-Separated Values (CSV)"
        }
    }
    
    var shortName: String {
        switch self {
        case .markdown: return "Markdown"
        case .csv: return "CSV"
        }
    }
}

/// Represents an individual recognized text cell candidate with its normalized bounding box.
struct TextCell: Equatable {
    let text: String
    let rect: CGRect
}

/// Represents a detected horizontal column lane across multiple rows.
struct ColumnLane {
    var minX: CGFloat
    var maxX: CGFloat
    var midX: CGFloat { (minX + maxX) / 2.0 }
}

/// Represents a detected structured table with headers and data rows.
struct DetectedTable: Equatable {
    let headers: [String]
    let rows: [[String]]
    let columnCount: Int
}

/// High-performance geometric bounding box clustering engine for tables and grids.
final class TableDetector {
    
    /// Detects whether recognized text observations form a structured table.
    /// Returns `DetectedTable` if columnar structure is confirmed, or `nil` if text is standard prose/code.
    static func detectTable(from observations: [VNRecognizedTextObservation]) -> DetectedTable? {
        let cells = extractCells(from: observations)
        return detectTable(from: cells)
    }
    
    /// Extracts individual cell candidates from Vision observations.
    /// Handles both pre-split cell observations and observations with internal tab or multi-space gaps.
    static func extractCells(from observations: [VNRecognizedTextObservation]) -> [TextCell] {
        var cells: [TextCell] = []
        let multiColumnRegex = try? NSRegularExpression(pattern: #"[^\s\t]+(?:\s[^\s\t]+)*"#)
        
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let fullText = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !fullText.isEmpty else { continue }
            
            // Check if observation contains multiple wide columns (separated by tabs or 2+ spaces)
            if (fullText.contains("\t") || fullText.range(of: #"\s{2,}"#, options: .regularExpression) != nil),
               let regex = multiColumnRegex {
                let nsString = fullText as NSString
                let matches = regex.matches(in: fullText, range: NSRange(location: 0, length: nsString.length))
                
                if matches.count > 1 {
                    for match in matches {
                        let tokenRange = match.range
                        let tokenText = nsString.substring(with: tokenRange)
                        if let swiftRange = Range(tokenRange, in: fullText) {
                            let subBox = (try? candidate.boundingBox(for: swiftRange))?.boundingBox ?? observation.boundingBox
                            cells.append(TextCell(text: tokenText, rect: subBox))
                        }
                    }
                    continue
                }
            }
            
            // Standard single-cell observation
            cells.append(TextCell(text: fullText, rect: observation.boundingBox))
        }
        
        return cells
    }
    
    /// Clusters raw text cells into rows and column lanes to identify tabular structures.
    static func detectTable(from cells: [TextCell]) -> DetectedTable? {
        // Fast pre-filter: tables require multiple cells
        guard cells.count >= 4 else { return nil }
        
        // 1. Group cells into rows based on vertical proximity.
        // In Vision coordinates, y=0 is bottom and y=1 is top. Sort descending (top to bottom).
        let sortedByY = cells.sorted { $0.rect.midY > $1.rect.midY }
        
        var rawRows: [[TextCell]] = []
        for cell in sortedByY {
            var placed = false
            for i in 0..<rawRows.count {
                let row = rawRows[i]
                let rowMidY = row.map { $0.rect.midY }.reduce(0, +) / CGFloat(row.count)
                let avgH = row.map { $0.rect.height }.reduce(0, +) / CGFloat(row.count)
                
                let tolerance = max(avgH * 0.65, 0.015)
                if abs(cell.rect.midY - rowMidY) <= tolerance {
                    rawRows[i].append(cell)
                    placed = true
                    break
                }
            }
            if !placed {
                rawRows.append([cell])
            }
        }
        
        // Sort each row left-to-right (minX ascending)
        for i in 0..<rawRows.count {
            rawRows[i].sort { $0.rect.minX < $1.rect.minX }
        }
        
        // A table must have at least 2 rows
        guard rawRows.count >= 2 else { return nil }
        
        // Multi-cell rows check: at least 2 rows must have 2 or more distinct cells
        let multiCellRows = rawRows.filter { $0.count >= 2 }
        guard multiCellRows.count >= 2 else { return nil }
        
        // Majority of rows in a table must have multiple columns, or >=2 rows for 2-3 row tables
        let multiCellRatio = Double(multiCellRows.count) / Double(rawRows.count)
        guard multiCellRatio >= 0.5 || (multiCellRows.count >= 2 && rawRows.count <= 3) else { return nil }
        
        // 2. Discover Column Lanes
        let maxCellsInRow = rawRows.map { $0.count }.max() ?? 0
        guard maxCellsInRow >= 2 else { return nil }
        
        // Seed lanes from the first row that has the maximum number of cells
        guard let seedRow = rawRows.first(where: { $0.count == maxCellsInRow }) else { return nil }
        var lanes: [ColumnLane] = seedRow.map { ColumnLane(minX: $0.rect.minX, maxX: $0.rect.maxX) }
        
        // Adjust and expand lanes from all other rows
        for row in rawRows {
            for cell in row {
                var matchedIndex: Int?
                var bestDistance = CGFloat.infinity
                
                for (idx, lane) in lanes.enumerated() {
                    let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                    let dist = abs(cell.rect.midX - lane.midX)
                    
                    if overlap > 0 || dist < 0.06 {
                        if dist < bestDistance {
                            bestDistance = dist
                            matchedIndex = idx
                        }
                    }
                }
                
                if let idx = matchedIndex {
                    lanes[idx].minX = min(lanes[idx].minX, cell.rect.minX)
                    lanes[idx].maxX = max(lanes[idx].maxX, cell.rect.maxX)
                } else {
                    lanes.append(ColumnLane(minX: cell.rect.minX, maxX: cell.rect.maxX))
                    lanes.sort { $0.minX < $1.minX }
                }
            }
        }
        
        // Merge heavily overlapping adjacent lanes
        lanes.sort { $0.minX < $1.minX }
        var mergedLanes: [ColumnLane] = []
        for lane in lanes {
            if let last = mergedLanes.last {
                let overlap = max(0, min(last.maxX, lane.maxX) - max(last.minX, lane.minX))
                let minWidth = min(last.maxX - last.minX, lane.maxX - lane.minX)
                if minWidth > 0 && (overlap / minWidth > 0.4 || lane.minX < last.maxX) {
                    mergedLanes[mergedLanes.count - 1].maxX = max(last.maxX, lane.maxX)
                    mergedLanes[mergedLanes.count - 1].minX = min(last.minX, lane.minX)
                    continue
                }
            }
            mergedLanes.append(lane)
        }
        
        // Valid table must have at least 2 distinct column lanes
        guard mergedLanes.count >= 2 && mergedLanes.count <= 25 else { return nil }
        
        // 3. Map cells to grid positions
        var grid: [[String]] = []
        for row in rawRows {
            var rowValues = Array(repeating: "", count: mergedLanes.count)
            for cell in row {
                var bestCol = 0
                var minDiff = CGFloat.infinity
                for (colIdx, lane) in mergedLanes.enumerated() {
                    let diff = abs(cell.rect.midX - lane.midX)
                    if diff < minDiff {
                        minDiff = diff
                        bestCol = colIdx
                    }
                }
                
                if rowValues[bestCol].isEmpty {
                    rowValues[bestCol] = cell.text
                } else {
                    rowValues[bestCol] += " " + cell.text
                }
            }
            grid.append(rowValues)
        }
        
        guard grid.count >= 2 else { return nil }
        let headers = grid[0]
        let dataRows = Array(grid.dropFirst())
        
        return DetectedTable(headers: headers, rows: dataRows, columnCount: mergedLanes.count)
    }
}

/// Formats detected tables into clean Markdown, CSV, or TSV.
final class TableFormatter {
    
    /// Formats a `DetectedTable` according to the requested `TableFormat`.
    static func format(_ table: DetectedTable, as format: TableFormat) -> String {
        switch format {
        case .markdown:
            return toMarkdown(table)
        case .csv:
            return toCSV(table)
        }
    }
    
    /// Formats as an aligned GitHub-Flavored Markdown table with proper header separators and escaped pipes.
    static func toMarkdown(_ table: DetectedTable) -> String {
        guard !table.headers.isEmpty else { return "" }
        let colCount = table.columnCount
        
        func sanitize(_ s: String) -> String {
            s.replacingOccurrences(of: "|", with: "\\|")
             .replacingOccurrences(of: "\n", with: " ")
             .trimmingCharacters(in: .whitespaces)
        }
        
        let sanitizedHeaders = (0..<colCount).map { i in
            i < table.headers.count ? sanitize(table.headers[i]) : ""
        }
        
        let sanitizedRows = table.rows.map { row in
            (0..<colCount).map { i in
                i < row.count ? sanitize(row[i]) : ""
            }
        }
        
        // Compute column widths for clean visual alignment
        var widths = (0..<colCount).map { max(sanitizedHeaders[$0].count, 3) }
        for row in sanitizedRows {
            for (i, cell) in row.enumerated() {
                widths[i] = max(widths[i], cell.count)
            }
        }
        
        var lines: [String] = []
        
        // Header line
        let headerLine = "| " + sanitizedHeaders.enumerated().map { i, h in
            h.padding(toLength: widths[i], withPad: " ", startingAt: 0)
        }.joined(separator: " | ") + " |"
        lines.append(headerLine)
        
        // Separator line
        let sepLine = "| " + widths.map { w in
            ":" + String(repeating: "-", count: max(w - 1, 2))
        }.joined(separator: " | ") + " |"
        lines.append(sepLine)
        
        // Data lines
        for row in sanitizedRows {
            let rowLine = "| " + row.enumerated().map { i, cell in
                cell.padding(toLength: widths[i], withPad: " ", startingAt: 0)
            }.joined(separator: " | ") + " |"
            lines.append(rowLine)
        }
        
        return lines.joined(separator: "\n")
    }
    
    /// Formats as standard RFC 4180 CSV with quotes and escapes.
    static func toCSV(_ table: DetectedTable) -> String {
        guard !table.headers.isEmpty else { return "" }
        let colCount = table.columnCount
        
        func escapeCSV(_ s: String) -> String {
            let trimmed = s.trimmingCharacters(in: .whitespaces)
            if trimmed.contains(",") || trimmed.contains("\"") || trimmed.contains("\n") {
                let escaped = trimmed.replacingOccurrences(of: "\"", with: "\"\"")
                return "\"\(escaped)\""
            }
            return trimmed
        }
        
        var lines: [String] = []
        let headerLine = (0..<colCount).map { i in
            i < table.headers.count ? escapeCSV(table.headers[i]) : ""
        }.joined(separator: ",")
        lines.append(headerLine)
        
        for row in table.rows {
            let rowLine = (0..<colCount).map { i in
                i < row.count ? escapeCSV(row[i]) : ""
            }.joined(separator: ",")
            lines.append(rowLine)
        }
        
        return lines.joined(separator: "\n")
    }
    
    /// Formats as standard Tab-Separated Values (TSV).
    static func toTSV(_ table: DetectedTable) -> String {
        guard !table.headers.isEmpty else { return "" }
        let colCount = table.columnCount
        
        func sanitizeTSV(_ s: String) -> String {
            s.replacingOccurrences(of: "\t", with: " ")
             .replacingOccurrences(of: "\n", with: " ")
             .trimmingCharacters(in: .whitespaces)
        }
        
        var lines: [String] = []
        let headerLine = (0..<colCount).map { i in
            i < table.headers.count ? sanitizeTSV(table.headers[i]) : ""
        }.joined(separator: "\t")
        lines.append(headerLine)
        
        for row in table.rows {
            let rowLine = (0..<colCount).map { i in
                i < row.count ? sanitizeTSV(row[i]) : ""
            }.joined(separator: "\t")
            lines.append(rowLine)
        }
        
        return lines.joined(separator: "\n")
    }
}
