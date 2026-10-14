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
    var title: String? = nil
    
    init(headers: [String], rows: [[String]], columnCount: Int, title: String? = nil) {
        self.headers = headers
        self.rows = rows
        self.columnCount = columnCount
        self.title = title
    }
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
        
        // 1. Group cells into visual baseline lines.
        // Rather than expanding intervals (which cascade and cause row avalanches in dense tables),
        // we cluster cells into distinct horizontal baseline lines based on midpoint proximity.
        var visualLines: [[TextCell]] = []
        for cell in sortedByY {
            var placed = false
            for i in 0..<visualLines.count {
                let lineMidY = visualLines[i].map { $0.rect.midY }.reduce(0, +) / CGFloat(visualLines[i].count)
                if abs(cell.rect.midY - lineMidY) <= avgHeight * 0.45 {
                    visualLines[i].append(cell)
                    placed = true
                    break
                }
            }
            if !placed {
                visualLines.append([cell])
            }
        }
        
        // Sort lines strictly from top to bottom
        visualLines.sort { l1, l2 in
            let m1 = l1.map { $0.rect.midY }.reduce(0, +) / CGFloat(l1.count)
            let m2 = l2.map { $0.rect.midY }.reduce(0, +) / CGFloat(l2.count)
            return m1 > m2
        }
        for i in 0..<visualLines.count {
            visualLines[i].sort { $0.rect.minX < $1.rect.minX }
        }
        
        guard visualLines.count >= 2 else { return nil }
        
        // 2. Extract potential table title / caption above the table
        var titleCaption: String? = nil
        var tableLines = visualLines
        if let first = tableLines.first, first.count == 1, first[0].rect.width > 0.45 {
            titleCaption = first[0].text
            tableLines.removeFirst()
        }
        
        guard tableLines.count >= 2 else { return nil }
        
        let maxItemsInLine = tableLines.map { $0.count }.max() ?? 0
        guard maxItemsInLine >= 2 else { return nil }
        
        // 3. Discover Column Lanes using table lines, ignoring wide spanning cells
        var allColumnCells: [TextCell] = []
        for line in tableLines {
            for cell in line {
                // Ignore wide spanning headers across columns when collecting column anchor boundaries
                if maxItemsInLine <= 3 || cell.rect.width < 0.35 {
                    allColumnCells.append(cell)
                }
            }
        }
        guard !allColumnCells.isEmpty else { return nil }
        
        var lanes: [ColumnLane] = []
        let sortedColCells = allColumnCells.sorted { $0.rect.minX < $1.rect.minX }
        for c in sortedColCells {
            var matchedIdx: Int?
            var maxOverlap: CGFloat = 0
            
            for (i, lane) in lanes.enumerated() {
                let overlap = max(0, min(c.rect.maxX, lane.maxX) - max(c.rect.minX, lane.minX))
                let minW = min(c.rect.width, lane.maxX - lane.minX)
                if (minW > 0 && overlap / minW >= 0.25) || abs(c.rect.minX - lane.minX) < 0.035 {
                    if overlap > maxOverlap || matchedIdx == nil {
                        maxOverlap = overlap
                        matchedIdx = i
                    }
                }
            }
            
            if let idx = matchedIdx {
                lanes[idx].minX = min(lanes[idx].minX, c.rect.minX)
                lanes[idx].maxX = max(lanes[idx].maxX, c.rect.maxX)
            } else {
                lanes.append(ColumnLane(minX: c.rect.minX, maxX: c.rect.maxX))
            }
        }
        
        // Merge overlapping adjacent lanes
        lanes.sort { $0.minX < $1.minX }
        var mergedLanes: [ColumnLane] = []
        for lane in lanes {
            if let last = mergedLanes.last {
                let overlap = max(0, min(last.maxX, lane.maxX) - max(last.minX, lane.minX))
                let minW = min(last.maxX - last.minX, lane.maxX - lane.minX)
                if minW > 0 && (overlap / minW >= 0.25 || lane.minX < last.maxX) {
                    mergedLanes[mergedLanes.count - 1].maxX = max(last.maxX, lane.maxX)
                    mergedLanes[mergedLanes.count - 1].minX = min(last.minX, lane.minX)
                    continue
                }
            }
            mergedLanes.append(lane)
        }
        
        // Valid table must have at least 2 distinct column lanes and not exceed reasonable grid limits
        guard mergedLanes.count >= 2 && mergedLanes.count <= 25 else { return nil }
        
        // 4. Map each visual line's cells to grid positions
        struct LineSlot {
            var slots: [String]
            var midY: CGFloat
            var count: Int { slots.filter { !$0.isEmpty }.count }
        }
        
        var mappedLines: [LineSlot] = []
        for line in tableLines {
            var slots = Array(repeating: "", count: mergedLanes.count)
            let lineMidY = line.map { $0.rect.midY }.reduce(0, +) / CGFloat(line.count)
            
            for cell in line {
                var matchedCols: [Int] = []
                for (colIdx, lane) in mergedLanes.enumerated() {
                    let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                    let minW = min(cell.rect.width, lane.maxX - lane.minX)
                    if minW > 0 && overlap / minW >= 0.3 {
                        matchedCols.append(colIdx)
                    }
                }
                
                if matchedCols.count > 1 {
                    // Spanning cell (e.g. multi-column super-header) - place in the first overlapping lane
                    let targetCol = matchedCols[0]
                    if slots[targetCol].isEmpty {
                        slots[targetCol] = cell.text
                    } else {
                        slots[targetCol] += " " + cell.text
                    }
                } else {
                    var bestCol = 0
                    var maxOverlap: CGFloat = 0
                    var minDistance: CGFloat = .infinity
                    
                    for (colIdx, lane) in mergedLanes.enumerated() {
                        let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                        if overlap > maxOverlap {
                            maxOverlap = overlap
                            bestCol = colIdx
                        }
                        let dist = abs(cell.rect.midX - lane.midX)
                        if dist < minDistance {
                            minDistance = dist
                            if maxOverlap == 0 {
                                bestCol = colIdx
                            }
                        }
                    }
                    
                    if slots[bestCol].isEmpty {
                        slots[bestCol] = cell.text
                    } else {
                        slots[bestCol] += " " + cell.text
                    }
                }
            }
            mappedLines.append(LineSlot(slots: slots, midY: lineMidY))
        }
        
        // 5. Consolidate consecutive multi-line rows
        // Consecutive visual lines belong to the same logical row if their vertical gap is small (<= 1.15 * avgHeight)
        // and they are NOT both completely filled data rows.
        var logicalRows: [[String]] = []
        var currentRow: LineSlot? = nil
        var lastLineMidY: CGFloat = 0
        
        for line in mappedLines {
            guard var curr = currentRow else {
                currentRow = line
                lastLineMidY = line.midY
                continue
            }
            
            let vertGap = lastLineMidY - line.midY
            let isBothCompletelyFull = (curr.count == mergedLanes.count && line.count == mergedLanes.count)
            let isIntraRowGap = vertGap <= avgHeight * 1.15
            
            if isIntraRowGap && !isBothCompletelyFull {
                for c in 0..<mergedLanes.count {
                    if !line.slots[c].isEmpty {
                        if curr.slots[c].isEmpty {
                            curr.slots[c] = line.slots[c]
                        } else {
                            curr.slots[c] += " " + line.slots[c]
                        }
                    }
                }
                lastLineMidY = line.midY
                currentRow = curr
            } else {
                logicalRows.append(curr.slots)
                currentRow = line
                lastLineMidY = line.midY
            }
        }
        if let curr = currentRow {
            logicalRows.append(curr.slots)
        }
        
        // A valid table must have at least 2 logical rows (e.g. 1 header + 1 data row)
        guard logicalRows.count >= 2 else { return nil }
        
        // Multi-cell rows check: at least 2 rows must have 2 or more distinct cells
        let multiCellRows = logicalRows.filter { row in row.filter { !$0.isEmpty }.count >= 2 }
        guard multiCellRows.count >= 2 else { return nil }
        
        // Majority of rows in a table must have multiple columns, or >=2 rows for 2-3 row tables
        let multiCellRatio = Double(multiCellRows.count) / Double(logicalRows.count)
        guard multiCellRatio >= 0.5 || (multiCellRows.count >= 2 && logicalRows.count <= 3) else { return nil }
        
        let headers = logicalRows[0]
        let dataRows = Array(logicalRows.dropFirst())
        
        return DetectedTable(headers: headers, rows: dataRows, columnCount: mergedLanes.count, title: titleCaption)
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
        
        var output = lines.joined(separator: "\n")
        if let title = table.title, !title.isEmpty {
            output = "**\(title)**\n\n" + output
        }
        return output
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
        
        var output = lines.joined(separator: "\n")
        if let title = table.title, !title.isEmpty {
            output = escapeCSV(title) + "\n" + output
        }
        return output
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
        
        var output = lines.joined(separator: "\n")
        if let title = table.title, !title.isEmpty {
            output = sanitizeTSV(title) + "\n" + output
        }
        return output
    }
}
