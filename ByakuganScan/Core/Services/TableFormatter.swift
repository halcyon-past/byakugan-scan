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
        let singleWordRegex = try? NSRegularExpression(pattern: #"[^\s\t]+"#)
        
        let allHeights = observations.map { $0.boundingBox.height }.sorted()
        let medianH = allHeights.isEmpty ? 0.05 : allHeights[allHeights.count / 2]
        
        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let fullText = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !fullText.isEmpty else { continue }
            
            // Skip vertical reading artifacts (e.g. Vision reading vertical columns of single digits like 'HAMHANTIN')
            if observation.boundingBox.height > medianH * 2.5 && observation.boundingBox.width < 0.12 {
                continue
            }
            
            let isTabOrMultiSpace = fullText.contains("\t") || fullText.range(of: #"\s{2,}"#, options: .regularExpression) != nil
            let isSnakeCaseMultiCol = observation.boundingBox.width > 0.30 && fullText.contains("_") && fullText.contains(" ")
            
            if (isTabOrMultiSpace || isSnakeCaseMultiCol),
               let regex = (isSnakeCaseMultiCol ? singleWordRegex : multiColumnRegex) {
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
        
        // Merge horizontally adjacent/touching tokens on the same line (e.g. 'purchase_' + '_number')
        for i in 0..<visualLines.count {
            var mergedLine: [TextCell] = []
            for cell in visualLines[i] {
                if let last = mergedLine.last {
                    let gap = cell.rect.minX - last.rect.maxX
                    let shouldJoinUnderscore = (last.text.hasSuffix("_") && cell.text.hasPrefix("_")) && gap <= 0.02
                    let shouldJoinTouch = (last.text.hasSuffix("_") || cell.text.hasPrefix("_")) && gap <= 0.005
                    if shouldJoinUnderscore || shouldJoinTouch {
                        let newText = (last.text.hasSuffix("_") && cell.text.hasPrefix("_"))
                            ? last.text + String(cell.text.dropFirst())
                            : last.text + cell.text
                        let newMinX = min(last.rect.minX, cell.rect.minX)
                        let newMaxX = max(last.rect.maxX, cell.rect.maxX)
                        let newMinY = min(last.rect.minY, cell.rect.minY)
                        let newMaxY = max(last.rect.maxY, cell.rect.maxY)
                        mergedLine[mergedLine.count - 1] = TextCell(text: newText, rect: CGRect(x: newMinX, y: newMinY, width: newMaxX - newMinX, height: newMaxY - newMinY))
                        continue
                    }
                }
                mergedLine.append(cell)
            }
            visualLines[i] = mergedLine
        }
        
        guard visualLines.count >= 2 else { return nil }
        
        // 2. Extract potential table title / caption above the table
        var titleCaption: String? = nil
        var tableLines = visualLines
        
        let tableMinX = cells.map { $0.rect.minX }.min() ?? 0
        let tableMaxX = cells.map { $0.rect.maxX }.max() ?? 1
        let tableMidX = (tableMinX + tableMaxX) / 2.0
        
        if let first = tableLines.first, first.count == 1 {
            let cell = first[0]
            let maxRest = tableLines.dropFirst().map { $0.count }.max() ?? 0
            let isWide = cell.rect.width > 0.35
            let isCentered = abs(cell.rect.midX - tableMidX) < 0.08 && maxRest >= 2
            
            var isAlignedWithColumnHeaderBelow = false
            if tableLines.count > 1 {
                let nextLine = tableLines[1]
                for nextCell in nextLine {
                    let leftDiff = abs(cell.rect.minX - nextCell.rect.minX)
                    let widthDiff = abs(cell.rect.width - nextCell.rect.width)
                    if leftDiff < 0.03 && widthDiff < 0.04 {
                        isAlignedWithColumnHeaderBelow = true
                        break
                    }
                }
            }
            
            if (isWide || isCentered) && !isAlignedWithColumnHeaderBelow {
                titleCaption = cell.text
                tableLines.removeFirst()
            }
        }
        
        guard tableLines.count >= 2 else { return nil }
        
        let maxItemsInLine = tableLines.map { $0.count }.max() ?? 0
        guard maxItemsInLine >= 2 else { return nil }
        
        // 3. Discover Column Lanes using table lines
        // Seed lanes from the first line that has maxItemsInLine (excluding spanning headers)
        guard let seedLine = tableLines.first(where: { line in
            line.count == maxItemsInLine && (maxItemsInLine <= 3 || line.allSatisfy { $0.rect.width < 0.40 })
        }) ?? tableLines.first(where: { $0.count == maxItemsInLine }) else { return nil }

        var lanes: [ColumnLane] = seedLine.map { ColumnLane(minX: $0.rect.minX, maxX: $0.rect.maxX) }

        // Expand lanes from all other lines
        for line in tableLines {
            for cell in line {
                if maxItemsInLine > 3 && cell.rect.width > 0.40 { continue } // skip wide spanning headers
                var matchedIdx: Int?
                var maxOverlap: CGFloat = 0
                var minDistance: CGFloat = .infinity
                var closestIdx: Int?

                for (i, lane) in lanes.enumerated() {
                    let overlap = max(0, min(cell.rect.maxX, lane.maxX) - max(cell.rect.minX, lane.minX))
                    let minW = min(cell.rect.width, lane.maxX - lane.minX)
                    if (minW > 0 && overlap / minW >= 0.20) || abs(cell.rect.minX - lane.minX) < 0.04 || abs(cell.rect.maxX - lane.maxX) < 0.04 {
                        if overlap > maxOverlap || matchedIdx == nil {
                            maxOverlap = overlap
                            matchedIdx = i
                        }
                    }
                    let dist = abs(cell.rect.midX - lane.midX)
                    if dist < minDistance {
                        minDistance = dist
                        closestIdx = i
                    }
                }

                if let idx = matchedIdx {
                    lanes[idx].minX = min(lanes[idx].minX, cell.rect.minX)
                    lanes[idx].maxX = max(lanes[idx].maxX, cell.rect.maxX)
                } else if let cIdx = closestIdx, minDistance < 0.08 {
                    lanes[cIdx].minX = min(lanes[cIdx].minX, cell.rect.minX)
                    lanes[cIdx].maxX = max(lanes[cIdx].maxX, cell.rect.maxX)
                } else {
                    lanes.append(ColumnLane(minX: cell.rect.minX, maxX: cell.rect.maxX))
                }
            }
        }

        // Merge overlapping adjacent lanes: REQUIRE meaningful overlap (>= 35%), never merge just because minX < last.maxX
        lanes.sort { $0.minX < $1.minX }
        var mergedLanes: [ColumnLane] = []
        for lane in lanes {
            if let last = mergedLanes.last {
                let overlap = max(0, min(last.maxX, lane.maxX) - max(last.minX, lane.minX))
                let minW = min(last.maxX - last.minX, lane.maxX - lane.minX)
                if minW > 0 && (overlap / minW >= 0.35) {
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
            
            // Two lines cannot merge if both have independent record identifiers (e.g. both have col 0 and col 1 populated, or both have numeric indices)
            let bothHaveIdentifiers = mergedLanes.count >= 2 && !curr.slots[0].isEmpty && !line.slots[0].isEmpty && !curr.slots[1].isEmpty && !line.slots[1].isEmpty
            let bothHaveNumericIndex = !curr.slots[0].isEmpty && !line.slots[0].isEmpty && Int(curr.slots[0]) != nil && Int(line.slots[0]) != nil
            
            let isContinuation = line.count == 1 || curr.count == 1 || (!bothHaveIdentifiers && !bothHaveNumericIndex)
            let canMerge = isIntraRowGap && !isBothCompletelyFull && isContinuation
            
            if canMerge {
                for c in 0..<mergedLanes.count {
                    if !line.slots[c].isEmpty {
                        if curr.slots[c].isEmpty {
                            curr.slots[c] = line.slots[c]
                        } else {
                            let existing = curr.slots[c]
                            let addition = line.slots[c]
                            if addition == "-" || addition == "_" {
                                curr.slots[c] = existing + addition
                            } else {
                                curr.slots[c] += " " + addition
                            }
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
