import Foundation

extension String {
    /// Trims whitespace, optionally de-hyphenates words split across line breaks, and optionally joins line breaks with a space.
    func formatted(
        preserveLineBreaks: Bool = true,
        trimWhitespace: Bool = true,
        joinWithSpace: Bool = false,
        smartDehyphenation: Bool = true
    ) -> String {
        var result = self
        
        if smartDehyphenation {
            result = String.dehyphenate(result)
        }
        
        if trimWhitespace {
            let lines = result.components(separatedBy: "\n").map {
                $0.trimmingCharacters(in: .whitespaces)
            }
            result = lines.joined(separator: "\n")
        }
        
        if !preserveLineBreaks || joinWithSpace {
            result = result.replacingOccurrences(of: "\n", with: " ")
        }
        
        return result.trimmingCharacters(in: joinWithSpace ? .whitespacesAndNewlines : .newlines)
    }
    
    /// Re-joins hyphenated word fragments split across line breaks.
    /// Only the rejoined word fragment moves to the upper line; subsequent words remain on the following line.
    static func dehyphenate(_ text: String) -> String {
        let normalized = text.replacingOccurrences(of: "\r\n", with: "\n")
        var lines = normalized.components(separatedBy: "\n")
        var i = 0
        
        let line1Regex = try? NSRegularExpression(pattern: #"(\b\p{L}+)-(?!\p{Pd})\s*$"#)
        let line2Regex = try? NSRegularExpression(pattern: #"^\s*(\p{L}+(?:[.,;:!?])?)(?:\s+(.*)|$)"#)
        
        guard let l1Regex = line1Regex, let l2Regex = line2Regex else { return text }
        
        while i < lines.count {
            var current = lines[i]
            let nsCurrent = current as NSString
            let match1 = l1Regex.firstMatch(in: current, range: NSRange(location: 0, length: nsCurrent.length))
            
            if let m1 = match1, i + 1 < lines.count {
                let nextLine = lines[i + 1]
                let nsNext = nextLine as NSString
                let match2 = l2Regex.firstMatch(in: nextLine, range: NSRange(location: 0, length: nsNext.length))
                
                if let m2 = match2 {
                    let word1Range = m1.range(at: 1)
                    let word1 = nsCurrent.substring(with: word1Range)
                    
                    let word2Range = m2.range(at: 1)
                    let word2 = nsNext.substring(with: word2Range)
                    
                    let joinedWord = word1 + word2
                    let fullMatch1Range = m1.range
                    current = nsCurrent.replacingCharacters(in: fullMatch1Range, with: joinedWord)
                    lines[i] = current
                    
                    if m2.numberOfRanges > 2 && m2.range(at: 2).location != NSNotFound {
                        let remainder = nsNext.substring(with: m2.range(at: 2))
                        lines[i + 1] = remainder
                        i += 1
                    } else {
                        lines.remove(at: i + 1)
                    }
                    continue
                }
            }
            i += 1
        }
        
        return lines.joined(separator: "\n")
    }
    
    /// Returns true if the string looks like a URL.
    var isURL: Bool {
        if let url = URL(string: self), url.scheme != nil, url.host != nil {
            return true
        }
        return false
    }
    
    /// Returns true if the string looks like an email address.
    var isEmail: Bool {
        let pattern = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#
        return range(of: pattern, options: .regularExpression) != nil
    }
    
    /// Returns true if the string looks like a phone number.
    var isPhoneNumber: Bool {
        let pattern = #"\+?[0-9\s\-\(\)]{7,}"#
        return range(of: pattern, options: .regularExpression) != nil
    }
}
