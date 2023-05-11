//
//  main.swift
//  ModuleMetrics
//
//  Created by Vsevolod Pavlovskyi on 10.05.2023.
//

import Foundation

fileprivate let args = CommandLine.arguments

/// Max batch size for concurrent computation. Default value is optimal, but can be configured with command line param.
fileprivate var batchSize = 5

switch args.count {
case 3:
    /// Parse maxConcurrentFiles parameter from command line args.
    batchSize = Int(args[2]) ?? batchSize
    
    fallthrough
case 2:
    let url = URL(fileURLWithPath: args[1])
    
    runProfiled {
        let totalMetrics = countMetricsForDirectory(
            url: url,
            batchSize: batchSize
        )

        print(totalMetrics)
    }
    
    exit(0)
default:
    print("Usage: \(args[0]) <directory> <batch-size (optional)>")
    
    exit(1)
}


