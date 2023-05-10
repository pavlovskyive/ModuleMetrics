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
    maxConcurrentFiles: Int = 10
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
    
    if files.count > maxConcurrentFiles {
        return countMetricsInParallel(files: files, maxConcurrentFiles: maxConcurrentFiles)
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
    maxConcurrentFiles: Int
) -> LinesInformation {
    let queue = DispatchQueue(label: "metrics", attributes: .concurrent)
    let group = DispatchGroup()

    /// Calculate the number of files per batch.
    let batchSize = (files.count + maxConcurrentFiles - 1) / maxConcurrentFiles

    /// Store the line count information for each batch.
    var batchInfos: [LinesInformation] = []

    for batchIndex in 0..<(files.count + batchSize - 1) / batchSize {
        let batchStart = batchIndex * batchSize
        let batchEnd = min((batchIndex + 1) * batchSize, files.count)

        group.enter()

        queue.async {
            let batchFiles = Array(files[batchStart..<batchEnd])
            let batchInfo = countMetricsSequentially(files: batchFiles)

            batchInfos.append(batchInfo)
            group.leave()
        }
    }

    group.wait()

    /// Combine the line count information for each batch.
    return combineLineInfos(batchInfos)
}

fileprivate func countMetricsSequentially(files: [String]) -> LinesInformation {
    combineLineInfos(files.map { LinesInformation(contents: $0) })
}

fileprivate func combineLineInfos(_ infos: [LinesInformation]) -> LinesInformation {
    infos.reduce(into: LinesInformation()) { result, current in
        result.logicalLines += current.logicalLines
        result.commentLines += current.commentLines
        result.blankLines += current.blankLines
    }
}
