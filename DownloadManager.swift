//
//  DownloadManager.swift
//  URL Download Updated
//
//  Created by Kamala Kannan N G on 22/02/25.
//

import Foundation

class DownloadManager : NSObject, URLSessionDownloadDelegate {
    var downloadTask : URLSessionDownloadTask!
    var session : URLSession!
    private var resumeData: Data?
    private let safeDownload = SafeDownload()

    init(url: URL) {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        downloadTask = session.downloadTask(with: url)
    }
    
    func getTotalFileSize() async -> String {
        return await safeDownload.getTotalFileSize()
    }
    
    func getDownloadedBytes() async -> String {
        return await safeDownload.getDownloadedBytes()
    }
    
    func getPercentageDownloaded() async -> String {
        return await safeDownload.getPercentageDownloaded()
    }
    
    func getDownloadState() async -> String {
        return await safeDownload.getDownloadState()
    }
    
    func getURL() -> URL {
        return downloadTask.originalRequest!.url!
    }
    
    func startDownload() {
        DispatchQueue.global(qos: .utility).async {
            guard self.getURL().scheme != nil, self.getURL().host != nil else {
                print("Invalid URL: \(self.getURL().absoluteString)")
                return
            }
            
            guard let destinationURL = self.getDestinationURL() else {
                print("Failed to get destination path!")
                return
            }
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                print("File Already Exists at: \(destinationURL.path)")
                return
            }
            
            print("Downloading \(self.getURL().lastPathComponent)...")
            self.downloadTask = self.session.downloadTask(with: self.getURL())
            self.downloadTask?.resume()
        }
    }
    
    func pauseDownload() {
        DispatchQueue.global(qos: .utility).async {
            guard let downloadTask = self.downloadTask else {
                print("No active download task to pause.")
                return
            }
            
            downloadTask.cancel { resumeDataOrNil in
                if let resumeData = resumeDataOrNil {
                    self.resumeData = resumeData
                    print("Download Paused")
                } else {
                    print("Failed to Pause the Download")
                }
            }
        }
    }
    
    func resumeDownload() {
        DispatchQueue.global(qos: .utility).async {
            guard let resumeData = self.resumeData else {
                print("No paused data available")
                return
            }
            
            if self.downloadTask.state == .running {
                print("Download is already running.")
                return
            }
            
            self.downloadTask = self.session.downloadTask(withResumeData: resumeData)
            self.downloadTask.resume()
            self.resumeData = nil
        }
    }
    
    func cancelDownload() {
        DispatchQueue.global(qos: .utility).async {
            guard let downloadTask = self.downloadTask else {
                print("No active download task to cancel.")
                return
            }
            
            downloadTask.cancel()
            self.downloadTask = nil
            self.resumeData = nil
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        Task {
            await safeDownload.updateDownloadProgress(totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let destinationURL = getDestinationURL() {
            moveFile(from: location, to: destinationURL)
        }
    }
    
    func getDestinationURL() -> URL? {
        if let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            return downloadsURL.appendingPathComponent(getURL().lastPathComponent)
        }
        return nil
    }
    
    func moveFile(from source: URL, to destination: URL) {
        do {
            try FileManager.default.moveItem(at: source, to: destination)
            print("Download Completed: \(destination.lastPathComponent) moved to \(destination.path)")
        } catch {
            print("Error Moving File: \(error)")
        }
    }
}
