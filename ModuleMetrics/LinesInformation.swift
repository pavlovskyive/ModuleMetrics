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
    var logicalLines: Int
    
    /// Number of comment lines in the code.
    var commentLines: Int
    
    /// Number of blank lines in the code.
    var blankLines: Int
    
    /// Total number of lines in the code.
    var physicalLines: Int {
        logicalLines + commentLines + blankLines
    }
    
    /// Ratio of comment lines to physical lines, expressed as a percentage.
    var commentingLevel: Float {
        Float(commentLines) / Float(physicalLines) * 100
    }
    
    /// Creates empty object for specific cases.
    init() {
        self.logicalLines = 0
        self.commentLines = 0
        self.blankLines = 0
    }
    
    /// Counts specific lines from contents.
    init(contents: String) {
        let lines = contents
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        var logicalLines = 0
        var blankLines = 0
        var commentLines = 0

        var isComment = false

        for line in lines {
            guard !line.isEmpty else {
                blankLines += 1
                
                continue
            }
            
            guard !line.starts(with: "/*") else {
                isComment = true
                commentLines += 1
                
                continue
            }
            
            guard !line.starts(with: "*/") else {
                isComment = false
                
                continue
            }
            
            guard
                !isComment,
                !line.contains("//")
            else {
                commentLines += 1
                
                continue
            }

            logicalLines += 1
        }
        
        self.logicalLines = logicalLines
        self.commentLines = commentLines
        self.blankLines = blankLines
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
