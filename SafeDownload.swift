//
//  SafeDownload.swift
//  URL Download Updated
//
//  Created by Kamala Kannan N G on 24/02/25.
//

import Foundation

actor SafeDownload {
    private var percentageDownloaded : String = ""
    private var downloadedBytes : String = ""
    private var totalFileSize : String = ""
    private var downloadState : URLSessionTask.State = .suspended
    
    func updateDownloadProgress(totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.downloadedBytes = formatSize(Double(totalBytesWritten))
        self.totalFileSize = formatSize(Double(totalBytesExpectedToWrite))
        let percentage: Double = (Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100
        self.percentageDownloaded = String(format: "%.2f", percentage)
    }
    
    func updateState(_ state: URLSessionTask.State) {
        self.downloadState = state
    }
    
    func getDownloadState() -> String {
        switch downloadState {
        case .running:
            return "Downloading..."
        case .suspended:
            return "Paused"
        case .canceling:
            return "Cancelling..."
        case .completed:
            return "Completed"
        default:
            return "Unknown State"
        }
    }
    
    func getTotalFileSize() -> String {
        return totalFileSize
    }

    func getDownloadedBytes() -> String {
        return downloadedBytes
    }

    func getPercentageDownloaded() -> String {
        return percentageDownloaded
    }
    
    func formatSize(_ bytes: Double) -> String {
        let kb = bytes / 1024
        let mb = kb / 1024
        let gb = mb / 1024

        if gb >= 1 {
            return String(format: "%.2f GB", gb)
        } else if mb >= 1 {
            return String(format: "%.2f MB", mb)
        } else if kb >= 1 {
            return String(format: "%.2f KB", kb)
        } else {
            return "\(totalFileSize) Bytes"
        }
    }
}
