import Foundation
import uplink_swift

//swiftlint:disable line_length
func uploadObject(project: ProjectResultStr, bucketName: String, localFullFileNameToUpload: String, storjUploadPath: String) {
    do {
        //Checking String is empty or not
        if (storjUploadPath.isEqual("")) || (localFullFileNameToUpload.isEqual("")) {
            //
            if storjUploadPath.isEqual("") {
                print("Please enter valid storjPath. \n")
            }
            //
            if localFullFileNameToUpload.isEqual("") {
                print("Please enter valid filename to upload.")
            }
            return
        }
        //
        let fileManager = FileManager.default
        // Check if file exits or not on localsystem
        if !fileManager.fileExists(atPath: localFullFileNameToUpload as String) {
            print("File : ", localFullFileNameToUpload, " \n . File does not exists. Please enter valid filename.")
            return
        }
        // Checking whether file is readbale or not
        if !fileManager.isReadableFile(atPath: localFullFileNameToUpload as String) {
            print("File : ", localFullFileNameToUpload, "\n . File is not readable")
            return
        }
        // File is readable
        let fileDetails = try fileManager.attributesOfItem(atPath: localFullFileNameToUpload as String)
        //Size of file uploading on storj V3
        let totalFileSizeInBytes: Int = fileDetails[FileAttributeKey.size] as? Int ?? Int(0)
        let fileHandle = FileHandle(forReadingAtPath: localFullFileNameToUpload)
        //
        if fileHandle != nil {
            //swiftlint:disable line_length
            //function for uploading file
            uploadFile(project: project, bucketName: bucketName, localFullFileNameToUpload: localFullFileNameToUpload, storjUploadPath: storjUploadPath, totalFileSizeInBytes: totalFileSizeInBytes, fileHandle: fileHandle)
        }
    } catch {
        print("Failed to upload file on storj V3 network :\n \(error)")
    }
}

//swiftlint:disable line_length function_parameter_count
func uploadFile(project: ProjectResultStr, bucketName: String, localFullFileNameToUpload: String, storjUploadPath: String, totalFileSizeInBytes: Int, fileHandle: FileHandle?) {
    do {
        var totalBytesRead = 0
        //
        var sizeToWrite = 0
        //
        var uploadOptions = UplinkUploadOptions()
        //
        var upload = try project.upload_Object(bucket: bucketName, key: storjUploadPath, uploadOptions: &uploadOptions)
        //
        let bufferSize = 1000000
        //
        var breakloop = false

        // Reading data from the file for uploading on storj V3
        while totalBytesRead<totalFileSizeInBytes {
            if totalFileSizeInBytes-totalBytesRead > bufferSize {
                sizeToWrite = bufferSize
            } else {
                sizeToWrite = totalFileSizeInBytes-totalBytesRead
            }
            if totalBytesRead>=totalFileSizeInBytes {
                break
            }
            autoreleasepool {
                do {
                    //
                    let data = fileHandle?.readData(ofLength: sizeToWrite)
                    //
                    var dataInUint = [UInt8](data.map {$0}!)
                    //
                    let dataBuffer = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
                    //
                    let bytesWritten = try  upload.write(data: dataBuffer, sizeToWrite: sizeToWrite)
                    //
                    totalBytesRead += bytesWritten
                    //
                    if (totalBytesRead>0) && (totalFileSizeInBytes>0) {
                        print("Data uploaded on storj V3 :  ", Float(totalBytesRead)/Float(totalFileSizeInBytes)*100, "%")
                    }
                    //
                    dataInUint.removeAll(keepingCapacity: false)
                    //
                } catch let error as StorjException {
                    breakloop = true
                    print("Error Code : \(error.code)")
                    print("Error Message : \(error.message)")
                } catch {
                    breakloop = true
                    print("Error while writing file :\n \(error)")
                }
            }
            //
            if breakloop {
                break
            }
        }
        setCustomMetaData(upload: &upload)
        //
        let uploadObjectInfo = try upload.info()
        //
        print("Upload Info")
        print(uploadObjectInfo)
    } catch {
        print("Failed to upload file on storj V3 network :\n \(error)")
    }
}
//
func setCustomMetaData(upload: inout UploadResultStr) {

    do {
        //
        let keyString: String = "change-me-to-desired-key"
        //
        let entries = UplinkCustomMetadataEntry(key: keyString, key_length: keyString.count, value: keyString, value_length: keyString.count)
        //
        let entriesArray = [entries]
        var customMetaDataObj = UplinkCustomMetadata(entries: entriesArray, count: entriesArray.count)
        //
        try upload.set_Custom_Metadata( customMetadata: &customMetaDataObj)
        print("Custom metadata added !!")
        print("Commiting object on storj ")
        try  upload.commit()
        print("Object uploaded successfully")
    } catch {

        print(error)

    }

}
