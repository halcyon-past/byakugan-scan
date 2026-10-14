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
                        var subBox: CGRect?
                        if let swiftRange = Range(tokenRange, in: fullText) {
                            if let candBox = try? candidate.boundingBox(for: swiftRange) {
                                subBox = candBox.boundingBox
                            }
                        }
                        
                        // Fallback: estimate proportional sub-box if Vision boundingBox fails or returns entire box
                        if subBox == nil || (subBox!.width >= observation.boundingBox.width * 0.95 && matches.count > 1) {
                            let fracStart = CGFloat(tokenRange.location) / CGFloat(nsString.length)
                            let fracWidth = CGFloat(tokenRange.length) / CGFloat(nsString.length)
                            let estX = observation.boundingBox.origin.x + fracStart * observation.boundingBox.width
                            let estW = fracWidth * observation.boundingBox.width
                            subBox = CGRect(x: estX, y: observation.boundingBox.origin.y, width: estW, height: observation.boundingBox.height)
                        }
                        
                        cells.append(TextCell(text: tokenText, rect: subBox ?? observation.boundingBox))
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
        
        let sortedByY = cells.sorted { $0.rect.midY > $1.rect.midY }
        let avgHeight = cells.map { $0.rect.height }.reduce(0, +) / CGFloat(cells.count)
        
        // 1. Group cells into Row Bands based on vertical proximity.
        // Dilation accounts for intra-cell line spacing so multi-line text cells stay within their row band.
        var yIntervals: [(minY: CGFloat, maxY: CGFloat, cells: [TextCell])] = []
        for cell in sortedByY {
            let dilation = min(avgHeight * 0.25, 0.015)
            let cellMinY = cell.rect.minY - dilation
            let cellMaxY = cell.rect.maxY + dilation
            
            var merged = false
            for i in 0..<yIntervals.count {
                let inv = yIntervals[i]
                if max(cellMinY, inv.minY) <= min(cellMaxY, inv.maxY) {
                    yIntervals[i].minY = min(inv.minY, cellMinY)
                    yIntervals[i].maxY = max(inv.maxY, cellMaxY)
                    yIntervals[i].cells.append(cell)
                    merged = true
                    break
                }
            }
            if !merged {
                yIntervals.append((minY: cellMinY, maxY: cellMaxY, cells: [cell]))
            }
        }
        
        // Ensure intervals are strictly in top-to-bottom reading order
        yIntervals.sort { ($0.minY + $0.maxY) > ($1.minY + $1.maxY) }
        
        guard yIntervals.count >= 2 else { return nil }
        
        // 2. Within each row band, consolidate multi-line cell fragments belonging to the same column
        var consolidatedRows: [[TextCell]] = []
        for band in yIntervals {
            var cellGroups: [[TextCell]] = []
            let lrCells = band.cells.sorted { $0.rect.minX < $1.rect.minX }
            
            for cell in lrCells {
                var placed = false
                for gIdx in 0..<cellGroups.count {
                    let group = cellGroups[gIdx]
                    let groupMinX = group.map { $0.rect.minX }.min() ?? 0
                    let groupMaxX = group.map { $0.rect.maxX }.max() ?? 0
                    
                    let overlap = max(0, min(cell.rect.maxX, groupMaxX) - max(cell.rect.minX, groupMinX))
                    let minW = min(cell.rect.width, groupMaxX - groupMinX)
                    
                    // Cells in the same column have significant horizontal overlap or matching left alignment
                    if (minW > 0 && overlap / minW >= 0.25) || (abs(cell.rect.minX - groupMinX) < 0.04) {
                        cellGroups[gIdx].append(cell)
                        placed = true
                        break
                    }
                }
                if !placed {
                    cellGroups.append([cell])
                }
            }
            
            var rowCells: [TextCell] = []
            for group in cellGroups {
                let topToBottom = group.sorted { $0.rect.midY > $1.rect.midY }
                let joinedText = topToBottom.map { $0.text }.joined(separator: " ")
                let minX = group.map { $0.rect.minX }.min() ?? 0
                let maxX = group.map { $0.rect.maxX }.max() ?? 0
                let minY = group.map { $0.rect.minY }.min() ?? 0
                let maxY = group.map { $0.rect.maxY }.max() ?? 0
                let unionRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                rowCells.append(TextCell(text: joinedText, rect: unionRect))
            }
            
            rowCells.sort { $0.rect.minX < $1.rect.minX }
            consolidatedRows.append(rowCells)
        }
        
        // A table must have at least 2 rows
        guard consolidatedRows.count >= 2 else { return nil }
        
        // Multi-cell rows check: at least 2 rows must have 2 or more distinct cells
        let multiCellRows = consolidatedRows.filter { $0.count >= 2 }
        guard multiCellRows.count >= 2 else { return nil }
        
        // Majority of rows in a table must have multiple columns, or >=2 rows for 2-3 row tables
        let multiCellRatio = Double(multiCellRows.count) / Double(consolidatedRows.count)
        guard multiCellRatio >= 0.5 || (multiCellRows.count >= 2 && consolidatedRows.count <= 3) else { return nil }
        
        // 3. Discover Column Lanes
        let maxCellsInRow = consolidatedRows.map { $0.count }.max() ?? 0
        guard maxCellsInRow >= 2 else { return nil }
        
        // Seed lanes from the first row that has the maximum number of cells
        guard let seedRow = consolidatedRows.first(where: { $0.count == maxCellsInRow }) else { return nil }
        var lanes: [ColumnLane] = seedRow.map { ColumnLane(minX: $0.rect.minX, maxX: $0.rect.maxX) }
        
        // Adjust and expand lanes from all other rows
        for row in consolidatedRows {
            for cell in row {
                var matchedIndex: Int?
                var bestOverlap: CGFloat = 0
                
                for (idx, lane) in lanes.enumerated() {
                    let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                    let minW = min(cell.rect.width, lane.maxX - lane.minX)
                    
                    if (minW > 0 && overlap / minW >= 0.25) || abs(cell.rect.minX - lane.minX) < 0.05 {
                        if overlap > bestOverlap {
                            bestOverlap = overlap
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
                if minWidth > 0 && (overlap / minWidth > 0.3 || lane.minX < last.maxX) {
                    mergedLanes[mergedLanes.count - 1].maxX = max(last.maxX, lane.maxX)
                    mergedLanes[mergedLanes.count - 1].minX = min(last.minX, lane.minX)
                    continue
                }
            }
            mergedLanes.append(lane)
        }
        
        // Valid table must have at least 2 distinct column lanes
        guard mergedLanes.count >= 2 && mergedLanes.count <= 25 else { return nil }
        
        // 4. Map each row's cells to grid positions
        var grid: [[String]] = []
        for row in consolidatedRows {
            var rowValues = Array(repeating: "", count: mergedLanes.count)
            for cell in row {
                var bestCol = 0
                var maxOverlap: CGFloat = 0
                var minGap: CGFloat = .infinity
                var closestCol = 0
                
                for (colIdx, lane) in mergedLanes.enumerated() {
                    let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                    if overlap > maxOverlap {
                        maxOverlap = overlap
                        bestCol = colIdx
                    }
                    let gap = max(0, max(lane.minX - cell.rect.maxX, cell.rect.minX - lane.maxX))
                    if gap < minGap {
                        minGap = gap
                        closestCol = colIdx
                    }
                }
                
                let targetCol = maxOverlap > 0 ? bestCol : closestCol
                if rowValues[targetCol].isEmpty {
                    rowValues[targetCol] = cell.text
                } else {
                    rowValues[targetCol] += " " + cell.text
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
