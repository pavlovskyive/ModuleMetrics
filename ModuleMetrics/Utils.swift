//
//  Utils.swift
//  ModuleMetrics
//
//  Created by Vsevolod Pavlovskyi on 10.05.2023.
//

import Foundation

// MARK: - Public interfaces.

/// Count codestyle metrics for swift files in directory.
func countMetricsForDirectory(
    url directory: URL,
    batchSize: Int = 10
) -> LinesInformation {
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(
        at: directory,
        includingPropertiesForKeys: nil,
        options: [.skipsHiddenFiles]
    ) { (url, error) -> Bool in
        print("Error: \(error.localizedDescription)")

        return true
    }
    
    var files: [String] = []
    while let fileURL = enumerator?.nextObject() as? URL {
        if
            fileURL.pathExtension == "swift",
            let contents = try? String(contentsOfFile: fileURL.relativePath)
        {
            files.append(contents)
        }
    }
    
    if files.count > batchSize {
        return countMetricsInParallel(files: files, batchSize: batchSize)
    } else {
        return countMetricsSequentially(files: files)
    }
}

/// Adding profiling layer to operation.
func runProfiled(operation: () -> Void) {
    let start = DispatchTime.now()
    
    operation()
    
    let end = DispatchTime.now()
    let elapsed = end.uptimeNanoseconds - start.uptimeNanoseconds
    let milliseconds = Double(elapsed) / 1_000_000
    
    print("\nElapsed time: \(milliseconds) milliseconds")
}

// MARK: - Private interfaces.

fileprivate func countMetricsInParallel(
    files: [String],
    batchSize: Int
) -> LinesInformation {
    let queue = DispatchQueue(label: "metrics", attributes: .concurrent)
    let group = DispatchGroup()

    var batchInfos: [LinesInformation] = []

    for index in stride(from: 0, to: files.count, by: batchSize) {
        let batchStart = index
        let batchEnd = min(index + batchSize, files.count)
        let batchFiles = Array(files[batchStart..<batchEnd])

        group.enter()

        queue.async {
            let batchInfo = countMetricsSequentially(files: batchFiles)

            queue.sync {
                batchInfos.append(batchInfo)
            }

            group.leave()
        }
    }

    group.wait()

    return batchInfos.combined
}

fileprivate func countMetricsSequentially(files: [String]) -> LinesInformation {
    files.map { LinesInformation(code: $0) }.combined
}
