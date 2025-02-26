//
//  main.swift
//  URL Download Updated
//
//  Created by Kamala Kannan N G on 22/02/25.
//

import Foundation

class Main {
    var activeDownloads: [Int : DownloadManager] = [:]
    
    func userInput() async {
        while true {
            print("""
                      Select an Option:
                      1. Enter URL to Download
                      2. Pause the Download
                      3. Resume the Download
                      4. Cancel the Download
                      5. Check Download Status
                      0. Exit
                      """)
            
            if let input = readLine(), let option = Int(input) {
                switch option {
                case 1:
                    print("Enter the URL: ")
                    if let input = readLine(), let url = URL(string: input) {
                        var tempDownloadID: Int
                        repeat {
                            tempDownloadID = Int.random(in: 1000...9999)
                        } while activeDownloads.keys.contains(tempDownloadID)
                        
                        let downloadID = tempDownloadID
                        let download = DownloadManager(url: url)

                        download.startDownload()
                        
                        self.activeDownloads[downloadID] = download
                        print("Download started with ID: \(downloadID)")
                        
                    } else {
                        print("Invalid URL! Please try again.")
                    }
                
                case 2:
                    print("Enter the id to pause the download: ")
                    if let input = readLine(), let downloadID = Int(input) {
                        if let download = activeDownloads[downloadID] {
                            download.pauseDownload()
                            print("Download paused with ID: \(downloadID)")
                        } else {
                            print("Download not found! Please try again.")
                        }
                    } else {
                        print("Invalid input!")
                    }
                    
                case 3:
                    print("Enter the id to resume the download: ")
                    if let input = readLine(), let downloadID = Int(input) {
                        if let download = activeDownloads[downloadID] {
                            download.resumeDownload()
                            print("Download resumed with ID: \(downloadID)")
                        } else {
                            print("Download not found! Please try again.")
                        }
                    } else {
                        print("Invalid input!")
                    }
                    
                case 4:
                    print("Enter the id to cancel the download: ")
                    if let input = readLine(), let downloadID = Int(input) {
                        if let download = activeDownloads[downloadID] {
                            download.cancelDownload()
                            print("Download cancelled with ID: \(downloadID)")
                        } else {
                            print("Download not found! Please try again.")
                        }
                    } else {
                        print("Invalid input!")
                    }
                    
                case 5:
                    if !activeDownloads.isEmpty {
                        await showDownloadStatus()
                    }
                    else {
                        print("No Downloads to Show!")
                    }
                    
                case 0:
                    print("Exiting...")
                    return
                    
                default:
                    print("Invalid option! Try again.")
                }
            } else {
                print("Invalid input!")
            }
        }
    }
    
    func showDownloadStatus() async {
        print("Download Status:")
        for (id, download) in activeDownloads {
            print("\(id). \(download.getURL().lastPathComponent): \(await download.getPercentageDownloaded())% [\(await download.getDownloadedBytes()) of \(await download.getTotalFileSize())] (Status: \(await download.getDownloadState()))")
        }
    }
}

let main = Main()
await main.userInput()
