// [Legal]
// Copyright 2022 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.5
import Esri.ArcGISExtras 1.1
import Esri.ArcGISRuntimeSamples 1.0

Item {
    property var currentItem
    property var downloadQueue : []
    property bool debug: false
    property bool failedToDownload: false

    FileInfo {
        id: fileInfo
    }

    FileInfo {
        id: dataPackageFileInfo
    }

    FileFolder {
        id: fileFolder
    }

    PermissionsHelper {
        id: permissionsHelper
        onRequestFilesystemAccessCompleted: {
            if (fileSystemAccessGranted) {
                downloadDataItems();
            } else {
                const msg = "Insufficient filesystem permissions";
                if (debug)
                    console.log(msg);

                failedToDownload = true;
                SampleManager.downloadInProgress = false;
                SampleManager.downloadText = msg;
            }
        }
    }

    function downloadAllDataItems() {
        SampleManager.downloadInProgress = true;
        downloadQueue = [];

        if (!permissionsHelper.fileSystemAccessGranted) {
            permissionsHelper.requestFilesystemAccess();
            failedToDownload = false;
            return;
        }

        for (let i = 0; i < SampleManager.samples.size; i++) {
            const sample = SampleManager.samples.get(i);
            for (let j = 0; j < sample.dataItems.size; j++) {
                if (sample.dataItems.size > 0) {
                    const dataItem = sample.dataItems.get(j);
                    fileInfo.filePath = dataItem.path;
                    if (fileInfo.exists && (!fileInfo.isFolder))
                        continue;

                    fileFolder.path = dataItem.path;
                    dataPackageFileInfo.filePath = dataItem.path + "/dataPackage.zip";
                    if (fileFolder.exists && dataPackageFileInfo.exists)
                        continue;

                    downloadQueue.push(dataItem);
                }
            }
        }
        downloadNextItem();
    }

    function downloadDataItems() {
        SampleManager.downloadInProgress = true;
        downloadQueue = [];

        if (!permissionsHelper.fileSystemAccessGranted) {
            permissionsHelper.requestFilesystemAccess();
            failedToDownload = false;
            return;
        }

        for (let i = 0; i < SampleManager.currentSample.dataItems.size; i++) {
            const dataItem = SampleManager.currentSample.dataItems.get(i);
            fileInfo.filePath = dataItem.path;
            if (fileInfo.exists && (!fileInfo.isFolder))
                continue;

            fileFolder.path = dataItem.path;
            dataPackageFileInfo.filePath = dataItem.path + "/dataPackage.zip";
            if (fileFolder.exists && dataPackageFileInfo.exists)
                continue;

            downloadQueue.push(dataItem);
        }
        downloadNextItem();
    }

    function downloadNextItem() {
        if (downloadQueue.length > 0) {
            SampleManager.downloadInProgress = true;
            const count = downloadQueue.length;
            SampleManager.downloadText = "Remaining items in queue: %1".arg(count);
            currentItem = downloadQueue.pop();
            SampleManager.downloadData(currentItem.itemId, System.resolvedPath(currentItem.path));
        } else {
            SampleManager.downloadText = "Downloads complete";
            SampleManager.downloadInProgress = false;
            SampleManager.doneDownloading();
            SampleManager.downloadProgress = 0.0;
        }
    }

    Connections {
        target: SampleManager

        function onDoneDownloadingPortalItem() {
            downloadNextItem();
        }

        function onDownloadDataFailed(itemId) {
            SampleManager.downloadText = "Download failed for item " + itemId;
        }

        function onUnzipFile(filePath, extractPath) {
            zipArchive.path = filePath;
            zipArchive.extractAll(extractPath);
        }
    }

    ZipArchive {
        id: zipArchive

        onExtractProgress: {
            if (debug)
                console.log("Extracting file " + fileName + " (" + percent + "%)");
        }
        onExtractError: {
            if (debug)
                console.log("Extract error " + fileName);
        }
        onExtractCompleted: {
            if (debug)
                console.log("Extract completed");
            downloadNextItem();
        }
    }
}