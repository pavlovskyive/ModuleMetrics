//
//  LinesInformation.swift
//  ModuleMetrics
//
//  Created by Vsevolod Pavlovskyi on 10.05.2023.
//

import Foundation

/// Structure to calculate and/or store information about lines of code.
struct LinesInformation {
    
    /// Number of logical lines in the code (i.e., code lines).
    private (set) var logicalLines: Int
    
    /// Number of comment lines in the code.
    private (set) var commentLines: Int
    
    /// Number of blank lines in the code.
    private (set) var blankLines: Int
    
    /// Total number of lines in the code.
    private (set) var physicalLines: Int
    
    /// Ratio of comment lines to physical lines, expressed as a percentage.
    var commentingLevel: Float {
        Float(commentLines) / Float(physicalLines) * 100
    }
    
    init(code: String = "") {
        guard !code.isEmpty else {
            self.physicalLines = 0
            self.logicalLines = 0
            self.blankLines = 0
            self.commentLines = 0
            
            return
        }
        
        self.physicalLines = LinesInformation.countPhysicalLines(code)
        self.logicalLines = LinesInformation.countSLOC(code)
        self.blankLines = LinesInformation.countBlankLines(code)
        self.commentLines = LinesInformation.countCommentLines(code)
    }
}

extension LinesInformation: CustomStringConvertible {
    var description: String {
        """
        Physical lines: \(physicalLines)
        Logical lines: \(logicalLines)
        Blank lines: \(blankLines)
        Comment lines: \(commentLines)
        Commenting level: \(commentingLevel)
        """
    }
}

extension Sequence where Element == LinesInformation {
    var combined: LinesInformation {
        reduce(into: LinesInformation()) { result, current in
            result.combine(with: current)
        }
    }
}

fileprivate extension LinesInformation {
    static let selectionStatements = Set(["if", "else", "elseif", "?", "try", "catch", "switch"])
    static let iterationStatements = Set(["for", "while", "repeat"])
    static let jumpStatements = Set(["return", "break", "exit", "continue"])
    static let expressionStatements = Set(["=", "(", "[", "{", "+=", "-=", ";"])
    static let compilerDirective = Set(["#"])
    
    static func removeComments(_ code: String) -> String {
        let singleLineCommentPattern = "//.*$"
        let multiLineCommentPattern = "/\\*.*?\\*/"
        
        var codeWithoutComments = code
        
        let singleLineCommentRegex = try! NSRegularExpression(pattern: singleLineCommentPattern, options: .anchorsMatchLines)
        codeWithoutComments = singleLineCommentRegex.stringByReplacingMatches(
            in: codeWithoutComments,
            options: [],
            range: NSRange(location: 0, length: codeWithoutComments.count),
            withTemplate: ""
        )
        
        let multiLineCommentRegex = try! NSRegularExpression(pattern: multiLineCommentPattern, options: [.dotMatchesLineSeparators, .caseInsensitive])
        codeWithoutComments = multiLineCommentRegex.stringByReplacingMatches(
            in: codeWithoutComments,
            options: [],
            range: NSRange(location: 0, length: codeWithoutComments.count),
            withTemplate: ""
        )
        
        return codeWithoutComments
    }
    
    static func countSLOC(_ code: String) -> Int {
        let code = removeComments(code)
        
        let tokens = code.components(separatedBy: .whitespacesAndNewlines)
        
        var slocCount = 0
        
        for token in tokens {
            guard !token.isEmpty else {
                continue
            }
            if selectionStatements.contains(token) ||
                iterationStatements.contains(token) ||
                jumpStatements.contains(token) ||
                compilerDirective.contains(token) {
                slocCount += 1
                
                continue
            }
            
            if expressionStatements.contains(token) {
                slocCount += 1
            }
        }
        
        return slocCount
    }
    
    static func countCommentLines(_ code: String) -> Int {
        let lines = code.components(separatedBy: .newlines)
        var commentLineCount = 0
        var isInsideComment = false
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.contains("/*") {
                isInsideComment = true
            }
            
            if isInsideComment || trimmedLine.contains("//") || trimmedLine.contains("*/") {
                commentLineCount += 1
            }
            
            if trimmedLine.contains("*/") {
                isInsideComment = false
            }
        }
        
        return commentLineCount
    }
    
    static func countBlankLines(_ code: String) -> Int {
        code.components(separatedBy: .newlines).filter(\.isEmpty).count
    }
    
    static func countPhysicalLines(_ code: String) -> Int {
        code.components(separatedBy: .newlines).count
    }
    
    mutating func combine(with second: LinesInformation) {
        physicalLines += second.physicalLines
        logicalLines += second.logicalLines
        blankLines += second.blankLines
        commentLines += second.commentLines
    }
}
