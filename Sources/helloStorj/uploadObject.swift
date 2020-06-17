import Foundation
import uplink_swift
import libuplink

// uploadObject will read file from local system and upload it on storj V3 network
// swiftlint:disable line_length
func uploadObject(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>, bucketName: NSString, localFullFileNameToUpload: NSString, storjUploadPath: NSString) {
    do {
        //Checking String is empty or not
        if (storjUploadPath.isEqual(to: "")) || (localFullFileNameToUpload.isEqual(to: "")) {
            if storjUploadPath.isEqual(to: "") {
                print("Please enter valid storjPath. \n")
            }
            if localFullFileNameToUpload.isEqual(to: "") {
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
        let fileHandle = FileHandle(forReadingAtPath: localFullFileNameToUpload as String)
        if fileHandle != nil {
            //function for uploading file
            uploadFile(storjSwift: &storjSwift, project: &project, bucketName: bucketName, localFullFileNameToUpload: localFullFileNameToUpload, storjUploadPath: storjUploadPath, totalFileSizeInBytes: totalFileSizeInBytes, fileHandle: fileHandle)
        }
    } catch {
        print(error)
    }
}
// swiftlint:disable line_length function_parameter_count function_body_length
func uploadFile(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>, bucketName: NSString, localFullFileNameToUpload: NSString, storjUploadPath: NSString, totalFileSizeInBytes: Int, fileHandle: FileHandle?) {
    do {
        var totalBytesRead = 0
        var sizeToWrite = 0
        var uploadOptions = UploadOptions()
        //
        var uploadResult = try storjSwift.upload_Object(project: &project, storjBucketName: bucketName, storjUploadPath: storjUploadPath, uploadOptions: &uploadOptions)
        //
        let bufferSize = 1000000
        //
        var breakloop = false
        // Reading data from the file for uploading on storj V3
        if uploadResult.upload != nil {
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
                        let data = fileHandle?.readData(ofLength: sizeToWrite)

                        var dataInUint = [UInt8](data.map {$0}!)

                        let dataBuffer = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
                        //
                        var dataUploadedOnStorj = try  storjSwift.upload_Write(upload: &uploadResult.upload, data: dataBuffer, sizeToWrite: sizeToWrite)
                        if dataUploadedOnStorj.error != nil {
                            print("Failed to write on storj V3 :\n Error code : \( dataUploadedOnStorj.error.pointee.code)\nError message : \(String(validatingUTF8: (dataUploadedOnStorj.error.pointee.message)!)!)")
                            breakloop = true
                        } else {
                           totalBytesRead += Int(dataUploadedOnStorj.bytes_written)
                        }
                        if (totalBytesRead>0) && (totalFileSizeInBytes>0) {
                            print("Data uploaded on storj V3 :  ", Float(totalBytesRead)/Float(totalFileSizeInBytes)*100, "%")
                        }
                        try storjSwift.free_Write_Result(writeResult: &dataUploadedOnStorj)
                        dataInUint.removeAll(keepingCapacity: false)
                    } catch {
                        print("Error while writing file :\n \(error)")
                    }
                }
                if breakloop {
                    break
                }
            }
            setCustomMetaData(storjSwift: &storjSwift, uploadResult: &uploadResult)
            //
            var uploadObjectInfo = try storjSwift.upload_Info(upload: &uploadResult.upload)
            if uploadObjectInfo.object != nil {
               print("\nObject key : \(String(validatingUTF8: (uploadObjectInfo.object.pointee.key)!)!) \nObject created  : \(unixTimeConvert(unixTime: uploadObjectInfo.object.pointee.system.created))\nObject size :  \(uploadObjectInfo.object.pointee.system.content_length)")
            } else {
                print("Error while setting custom metadata \nError code :  \(uploadObjectInfo.error.pointee.code) Error message : \(String(validatingUTF8: (uploadObjectInfo.error.pointee.message)!)!)")
            }
            //
            try storjSwift.free_Object_Result(objectResult: &uploadObjectInfo)
        } else {
           print("Error while uploading object :\n Error code : \(uploadResult.error.pointee.code) Error message : \(String(validatingUTF8: (uploadResult.error.pointee.message)!)!)")
        }
        try storjSwift.free_Upload_Result(uploadResult: &uploadResult)
    } catch {
        print("Failed to upload file on storj V3 network :\n \(error)")
    }
}

func setCustomMetaData(storjSwift:inout Storj, uploadResult: inout UploadResult) {
    do {
    var entries = CustomMetadataEntry()
    let keyString: NSString = "change-me-to-desired-key"
    let ptrToKeyString = UnsafeMutablePointer<CChar>(mutating: keyString.utf8String)
    //
    entries.key = ptrToKeyString
    entries.key_length = keyString.length
    entries.value = ptrToKeyString
    entries.value_length = keyString.length
    //
    var entriesArray = [entries]
    var customMetaDataObj = CustomMetadata()
    //
    customMetaDataObj.count = entriesArray.count
    let ptrToEntriesArray = UnsafeMutablePointer<CustomMetadataEntry>.allocate(capacity: entriesArray.count)
    ptrToEntriesArray.initialize(from: &entriesArray, count: entriesArray.count)
    customMetaDataObj.entries = ptrToEntriesArray
    //
    print("Setting custom metadata")
    let setCutomMetaDataResult = try storjSwift.upload_Set_Custom_Metadata(upload: &uploadResult.upload, customMetaDataObj: customMetaDataObj)
    if setCutomMetaDataResult != nil {
        print("Error while setting metadata")
        print("Error code : ", setCutomMetaDataResult?.pointee.code ?? 0, "Error message : ", String(validatingUTF8: (setCutomMetaDataResult?.pointee.message)!)!)
    } else {
        print("Custom metadata added !!")
    }
    print("Commiting object on storj ")
    var ptrToErrorObjectCommit = try  storjSwift.upload_Commit(upload: &uploadResult.upload)
    //
    if ptrToErrorObjectCommit != nil {
        print("Error while uploading object")
        print("Error code : ", ptrToErrorObjectCommit?.pointee.code ?? 0, "Erro message : ", String(validatingUTF8: (ptrToErrorObjectCommit?.pointee.message)!)!)
        try storjSwift.free_Error(error: &(ptrToErrorObjectCommit)!)
    } else {
        print("Object uploaded successfully")
    }
    } catch {
        print(error)
    }
}
