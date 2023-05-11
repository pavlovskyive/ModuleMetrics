//
//  Tests.swift
//  Tests
//
//  Created by Vsevolod Pavlovskyi on 11.05.2023.
//

import XCTest

final class Tests: XCTestCase {
    func testExample() {
        let code =
        """
        // here is inline comment
        /*
        and this is
        multiline comment
        */
        
        let a = b
        
        if a > 5 {
            print(a) // Here is one logical SLOC per line
        }
        """
        
        let metrics = LinesInformation(code: code)
        
        XCTAssertEqual(metrics.physicalLines, 11)
        XCTAssertEqual(metrics.logicalLines, 3)
        XCTAssertEqual(metrics.commentLines, 6)
        XCTAssertEqual(metrics.blankLines, 2)
    }
    
    func testExampleMultilineSLOC() {
        let code =
        """
        // here is inline comment
        /*
        and this is
        multiline comment
        */
        
        let a = b
        
        if a > 5 { print(a) } // this is multiple logic lines and a comment line
        """
        
        let metrics = LinesInformation(code: code)
        
        XCTAssertEqual(metrics.physicalLines, 9)
        XCTAssertEqual(metrics.logicalLines, 3)
        XCTAssertEqual(metrics.commentLines, 6)
        XCTAssertEqual(metrics.blankLines, 2)
    }
}
