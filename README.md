# Swift URL Downloader

## Overview
Swift URL Downloader is a command-line application that enables users to download files asynchronously by entering a URL. The application supports essential download management features, including pause, resume, and cancel, while running efficiently in the background without blocking user input.

## Features
- **Asynchronous Downloading**: Uses `URLSessionDownloadTask` to download files in the background.
- **Multithreading**: Utilizes `DispatchQueue.global(qos: .utility)` to perform downloads on a separate thread.
- **Safe State Management**: Implements an actor (`SafeDownload`) to ensure thread-safe updates for download progress.
- **Pause & Resume**: Supports pausing downloads using `resumeData` and resuming them later.
- **Non-blocking Execution**: The app remains responsive while managing multiple downloads.
- **Automatic File Handling**: Saves downloaded files to the system's Downloads folder.

## Installation & Usage
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/Swift-URL-Downloader.git
   cd Swift-URL-Downloader
   ```
2. Open the project in Xcode or run the Swift files using:
   ```sh
   swift main.swift
   ```

## How It Works
1. The user selects an option from the menu.
2. If downloading, the app generates a unique ID and starts downloading the file in the background.
3. The user can pause, resume, or cancel a download using the corresponding ID.
4. The app tracks progress and displays the status of active downloads asynchronously.

## Example Usage
```
Select an Option:
1. Enter URL to Download
2. Pause the Download
3. Resume the Download
4. Cancel the Download
5. Check Download Status
0. Exit
```

## Future Enhancements
- Implement a GUI for better user interaction.
- Add support for concurrent multiple downloads.
- Enable automatic retries for failed downloads.

## License
This project is licensed under the MIT License.

## Author
**Kamala Kannan N G**

