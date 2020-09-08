import Foundation
import uplink_swift

//swiftlint:disable line_length
func downloadObject(project:inout ProjectResultStr, bucketName: String, localFullFileLocationToStore: String, storjDownloadPath: String) {
    //
    do {
        print("Fetching Object Info of : ", storjDownloadPath, "Bucket : ", storjDownloadPath)
        var downloadFileSizeOnStorj: Int64 = 0
        let objectResultObjInfoObject = try project.stat_Object(bucket: bucketName, key: storjDownloadPath)
        //
        print("Object Info")
        print("Object name : \(objectResultObjInfoObject.key)")
        print("Object size : \(objectResultObjInfoObject.system.content_length)")
            downloadFileSizeOnStorj = objectResultObjInfoObject.system.content_length
        print("Object created \(unixTimeConvert(unixTime: objectResultObjInfoObject.system.created))")
        print("Downloading \(storjDownloadPath) Storj Object as \(localFullFileLocationToStore) file...")
        if (!storjDownloadPath.isEqual("")) && (!localFullFileLocationToStore.isEqual("")) {
            downloadFile(project: &project, bucketName: bucketName, downloadFileSizeOnStorj: downloadFileSizeOnStorj)
        } else {
            if storjDownloadPath.isEqual("") {
                print("Plese enter storjFullFilename for downloading object.\n")
            }
            if localFullFileLocationToStore.isEqual("") {
                print("Please enter localFullFilename for downloading object")
            }
        }
    } catch {
        print("Error while downloading file")
        print(error)
    }
    //
}
// downloadFile will download object from storj V3 network
// swiftlint:disable line_length function_body_length
func downloadFile(project:inout ProjectResultStr, bucketName: String, downloadFileSizeOnStorj: Int64) {
    do {
        //Setting upload options
        var downloadOptions = DownloadOptions(offset: 0, length: -1)
        //
        let download = try  project.download_Object(bucket: bucketName, key: storjDownloadPath, downloadOptions: &downloadOptions)
        print("Storj Download Path : ", storjDownloadPath)
        let fileManger = FileManager.default
        // Checking file already exits or not
        if fileManger.fileExists(atPath: localFullFileLocationToStore as String) {
            // If file alreasy exits on local system then delete file
            if fileManger.isDeletableFile(atPath: localFullFileLocationToStore as String) {
                _ = try fileManger.removeItem(atPath: localFullFileLocationToStore as String)
            } else {
                print("File is not deletableFile.")
                return
            }
        }
        //Creating file for writing data from storj V3 network
        if !fileManger.createFile(atPath: localFullFileLocationToStore as String, contents: nil, attributes: nil) {
            print("Error while creating file on local system.")
            return
        }
        //Checking while file is writable or not
        if !fileManger.isWritableFile(atPath: localFullFileLocationToStore as String) {
            print("File is not writable")
            return
        }
        let writehandel = FileHandle(forWritingAtPath: localFullFileLocationToStore as String)
        if writehandel == nil {
            print("Failed to open file from storj V3 network")
            return
        }
        //
        let bufferSize = 1000000
        let sizeToWrite = bufferSize
        var downloadTotal = 0
        var buff = Data(capacity: bufferSize)
        //
        while true {
            //Creating array for reading data from storj V3 network
            var receivedDataArray: [UInt8] = Array(repeating: 0, count: sizeToWrite)
            let ptrtoreceivedData = receivedDataArray.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
            //
            let bytesRead = try  download.read(data: ptrtoreceivedData, sizeToWrite: sizeToWrite)
                //
            let downloadedData = bytesRead
            if downloadedData < bufferSize {
                    receivedDataArray.removeSubrange(downloadedData..<bufferSize)
            }
            //Add data into buffer for writing into file
            buff.append(contentsOf: receivedDataArray)
            //Writing into file
            let _: Void? = writehandel?.write((buff))
            //Clearning buffer data
            buff.removeAll()
            //
            downloadTotal += downloadedData
            if (downloadTotal>0) && (downloadFileSizeOnStorj>0) {
                print("Data downloaded form storj V3 :  ", Float(downloadTotal)/Float(downloadFileSizeOnStorj)*100, "%")
            }
            //
            if downloadTotal>=downloadFileSizeOnStorj {
                break
            }
        }
        //Closing file handle
        if writehandel != nil {
            writehandel?.closeFile()
        }
        //Fetching object info
        let downloadObjectInfo = try download.info()
        print("Download object info \nObject name : \( downloadObjectInfo.key) \nObject size : \(downloadObjectInfo.system.content_length) \nObject created on : \(unixTimeConvert(unixTime: downloadObjectInfo.system.created))")
        //
        try download.close()
        //
        print("Download complete")
    } catch {
        print("Failed to download file from storj V3 network : \n \(error)")
    }
}
