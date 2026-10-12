import Foundation

extension String {
    /// Trims whitespace and optionally joins line breaks with a space.
    func formatted(preserveLineBreaks: Bool, trimWhitespace: Bool, joinWithSpace: Bool) -> String {
        var result = self
        
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
