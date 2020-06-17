import Foundation
import uplink_swift
import libuplink
//Download file
// swiftlint:disable line_length
func downloadObject(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>, bucketName: NSString, localFullFileLocationToStore: NSString, storjDownloadPath: NSString) {
    do {
        print("Fetching Object Info of : ", storjDownloadPath, "Bucket : ", storjDownloadPath)
        var downloadFileSizeOnStorj: Int64 = 0
        var objectResultObjInfoObject = try storjSwift.stat_Object(project: &project, bucketName: bucketName, storjObjectName: storjDownloadPath)
        if objectResultObjInfoObject.object != nil {
            print("Object Info")
            print("Object name : ", String(validatingUTF8: objectResultObjInfoObject.object.pointee.key!)!)
            print("Object size : ", objectResultObjInfoObject.object.pointee.system.content_length)
            downloadFileSizeOnStorj = objectResultObjInfoObject.object.pointee.system.content_length
            print("Object created", unixTimeConvert(unixTime: objectResultObjInfoObject.object.pointee.system.created))
        } else {
            print("Failed to fetch object Info ")
            print("Error Code : ", objectResultObjInfoObject.error.pointee.code, "Error Message : ", String(validatingUTF8: (objectResultObjInfoObject.error.pointee.message)!)!)
        }
        try storjSwift.free_Object_Result(objectResult: &objectResultObjInfoObject)
        print("Downloading ", storjDownloadPath, " Storj Object as ", localFullFileLocationToStore, " file...")
        if (!storjDownloadPath.isEqual(to: "")) && (!localFullFileLocationToStore.isEqual(to: "")) {
            downloadFile(storjSwift: &storjSwift, project: &project, bucketName: bucketName, downloadFileSizeOnStorj: downloadFileSizeOnStorj)
        } else {
            if storjDownloadPath.isEqual(to: "") {
                print("Plese enter storjFullFilename for downloading object.\n")
            }
            if localFullFileLocationToStore.isEqual(to: "") {
                print("Please enter localFullFilename for downloading object")
            }
        }
    } catch {
        print("Error while downloading file")
        print(error)
    }
}
// downloadFile will download object from storj V3 network
// swiftlint:disable line_length function_body_length cyclomatic_complexity
func downloadFile(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>, bucketName: NSString, downloadFileSizeOnStorj: Int64) {
    do {
        //Setting upload options
        var downloadOptions = DownloadOptions(offset: 0, length: -1)
        //
        var downloadResult = try  storjSwift.download_Object(project: &project, storjBucketName: bucketName, storjObjectName: storjDownloadPath, downloadOptions: &downloadOptions)
        print("Storj Download Path : ", storjDownloadPath)
        if downloadResult.download != nil {
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
                var ptrToReadResult = try  storjSwift.download_Read(download: &downloadResult.download, data: ptrtoreceivedData, sizeToWrite: sizeToWrite)
                //
                if ptrToReadResult.error == nil {
                    let downloadedData = ptrToReadResult.bytes_read
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
                    try storjSwift.free_Read_Result(readResult: &ptrToReadResult)
                } else {
                    print("Error while reading data from storjV3 network")
                    break
                }
            }
            //Closing file handle
            if writehandel != nil {
                writehandel?.closeFile()
            }
            //Fetching object info
            var downloadObjectInfo = try storjSwift.download_Info(download: &(downloadResult.download)!)
            if downloadObjectInfo.object != nil {
                print("Download object info \nObject name : \(String(validatingUTF8: downloadObjectInfo.object.pointee.key!)!) \nObject size : \(downloadObjectInfo.object.pointee.system.content_length) \nObject created on : \(unixTimeConvert(unixTime: downloadObjectInfo.object.pointee.system.created))")
            } else {
                print("Failed to get object Info : \n Error Code : \(downloadObjectInfo.error.pointee.code) \n Error Message : \(String(validatingUTF8: (downloadObjectInfo.error.pointee.message)!)!)")
            }
            //
            try storjSwift.free_Object_Result(objectResult: &downloadObjectInfo)
            //
            var ptrToCloseError = try storjSwift.close_Download(download: &downloadResult.download)
            //
            if ptrToCloseError != nil {
                print("FAILed to download \n Error Code : ", ptrToCloseError?.pointee.code ?? 0, "Error Message")
                try storjSwift.free_Error(error: &(ptrToCloseError)!)
            } else {
                print("Download complete")
            }
    } else {
       print("Error While Uploading Object \n Error Code : \(downloadResult.error.pointee.code) \nError Message : \(String(validatingUTF8: (downloadResult.error.pointee.message)!)!)")
    }
    try storjSwift.free_Download_Result(downloadResult: &downloadResult)
    } catch {
        print("Failed to download file from storj V3 network : \n \(error)")
    }
}
