//
//  main.swift
//  ModuleMetrics
//
//  Created by Vsevolod Pavlovskyi on 10.05.2023.
//

import Foundation

fileprivate let args = CommandLine.arguments

/// Max batch size for concurrent computation. Default value is optimal, but can be configured with command line param.
fileprivate var maxConcurrentFiles = 10

switch args.count {
case 3:
    /// Parse maxConcurrentFiles parameter from command line args.
    maxConcurrentFiles = Int(args[2]) ?? maxConcurrentFiles
    
    fallthrough
case 2:
    let url = URL(fileURLWithPath: args[1])
    
    runProfiled {
        let totalMetrics = countMetricsForDirectory(
            url: url,
            maxConcurrentFiles: maxConcurrentFiles
        )

        print(totalMetrics)
    }
    
    exit(0)
default:
    print("Usage: \(args[0]) <directory> <max-concurrent-files (optional)>")
    
    exit(1)
}


