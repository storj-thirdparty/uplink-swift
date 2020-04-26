//
// main.swift
// example Swift code, utilizing storj-swift bindings
//

import Foundation
import storj_swift
import Clibuplink
/* Storj V3 network configuration parameters */
//
// API key
var storjApiKey: NSString = "change-me-to-the-api-key-created-in-satellite-gui"
// Satellite address
var storjSatellite: NSString = "us-central-1.tardigrade.io:7777"
// Encryption passphrase
var storjEncryptionPassphrase: NSString = "you'll never guess this"
// Bucket name
var storjBucket: NSString = "change-me-to-desired-bucket-name"
// Upload path within the bucket, whereto the sample message is to be uploaded.
var storjUploadPath: NSString = "optionalpath/requiredfilename.txt"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath: NSString = "optionalpath/requiredfilename.txt"
// Full file name, including path, of the local system, to be uploaded to Storj bucket.
var localFullFileNameToUpload: NSString = "optionalpath/requiredfilename"
// Local full path, where the Storj object is to be stored after download.
var localFullFileLocationToStore: NSString = "optionalpath/requiredfilename"
// Create an object of the Storj-Swift bindings, so as to access functions.
//Stroj("change-me-to-dylib-location") if not provided then default path will be storj-swift/Sources/ClibUplink/include
var libUplinkSwiftObj = Storj("")
//Converting Time
func unixTimeConvert(unixTime:Int64)->(String) {
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixTime))
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}
//
do {
    print("Getting Accessig using :\nSatellite Address : \(storjSatellite)\nAPI Key : \(storjApiKey)\nEncryption Phassphrase : \(storjEncryptionPassphrase)")
    var accessResultObj = try libUplinkSwiftObj.request_Access_With_Passphrase(satelliteAddress: storjSatellite, apiKey: storjApiKey, encryptionPassphrase: storjEncryptionPassphrase);
    //Checking Whether Error or Access is return.
    if (accessResultObj.access != nil) {
        print("Access granted !!")
        print("Opening project on storj V3 network.....")
        var projectResultObj = try libUplinkSwiftObj.open_Project(ptrToAccess: &accessResultObj.access)
        //
        if (projectResultObj.project != nil) {
            print("\nGetting info about bucket : ",storjBucket)
            //
            var bucketResultObj = try libUplinkSwiftObj.stat_Bucket(ptrToProject: &projectResultObj.project, bucketName: storjBucket)
            //
            if (bucketResultObj.bucket != nil) {
                print("Bucket Information \nBucket created : ",unixTimeConvert(unixTime: bucketResultObj.bucket.pointee.created),"Bucket Name : ",String(validatingUTF8:bucketResultObj.bucket.pointee.name!)!)
            }else if (bucketResultObj.error != nil) {
                print("Failed to get information about Bucket \n Error Code : ",bucketResultObj.error.pointee.code,"\n Error Message : ",String(validatingUTF8: bucketResultObj.error.pointee.message!)!)
            }
            //
            try libUplinkSwiftObj.free_Bucket_Result(bucketResultObj: &bucketResultObj)
            //
            print("\nCreating Bucket : ",storjBucket)
            //
            var CreateBucketResultObj = try  libUplinkSwiftObj.create_Bucket(ptrToProject: &projectResultObj.project, bucketName: storjBucket)
            //
            if (CreateBucketResultObj.bucket != nil) {
               print("Bucket Created !!")
                print("Bucket Name : ",String(validatingUTF8: CreateBucketResultObj.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:CreateBucketResultObj.bucket.pointee.created))
            } else {
                print("Failed to create Bucket Bucket \n Error Code : ",CreateBucketResultObj.error.pointee.code,"\n Error Message : ",String(validatingUTF8: CreateBucketResultObj.error.pointee.message!)!)
            }
            try libUplinkSwiftObj.free_Bucket_Result(bucketResultObj: &CreateBucketResultObj)
            //
            print("\nGetting info of created bucket")
            var lO_EnsureBucketResult = try  libUplinkSwiftObj.ensure_Bucket(ptrToProject: &projectResultObj.project, bucketName: storjBucket)
            if (lO_EnsureBucketResult.bucket != nil) {
                print("Bucket Name : ",String(validatingUTF8: lO_EnsureBucketResult.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:lO_EnsureBucketResult.bucket.pointee.created))
            } else {
                print("Failed to get information of Bucket \n Error Code : ",lO_EnsureBucketResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_EnsureBucketResult.error.pointee.message!)!)
            }
            //
            try libUplinkSwiftObj.free_Bucket_Result(bucketResultObj: &lO_EnsureBucketResult)
            //
            print("\n\nListing Buckets...")
            listBucket( libUplinkSwiftObj:&libUplinkSwiftObj,ptrToProject: &projectResultObj.project)
            //
            print("\n\nUploading Object...")
            UploadObject( libUplinkSwiftObj:&libUplinkSwiftObj,ptrToProject: &projectResultObj.project, bucketName: storjBucket,localFullFileNameToUpload:localFullFileNameToUpload,storjUploadPath:storjUploadPath)
            //
            print("\n\nDownloading Object...")
            DownloadObject(libUplinkSwiftObj:&libUplinkSwiftObj,ptrToProject: &projectResultObj.project, bucketName: storjBucket,localFullFileLocationToStore:localFullFileLocationToStore,storjDownloadPath:storjDownloadPath)
            //
            print("\n\nListing Object")
            ListObjects(libUplinkSwiftObj:&libUplinkSwiftObj,ptrToProject: &projectResultObj.project,bucketName:storjBucket)
            //
            print("Creating Share Access")
            var lO_Permission = Permission()
            lO_Permission.allow_delete = true
            lO_Permission.allow_upload = true
            var lO_SharePrefix = SharePrefix()
            let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucket.utf8String)
            let objectPrefix : NSString = "change-me-to-desired-object-prefix";
            let ptrToPrefix = UnsafeMutablePointer<CChar>(mutating: objectPrefix.utf8String)
            lO_SharePrefix.bucket = ptrToBucketName
            lO_SharePrefix.prefix = ptrToPrefix
            let sharePrefixArray = [lO_SharePrefix]
            var ptrTosharePrefix = UnsafeMutablePointer<SharePrefix>(mutating: sharePrefixArray)
            var lO_sharedAccess = try libUplinkSwiftObj.access_Share(ptrToAccess: &accessResultObj.access,permission:&lO_Permission,ptrToPrefix:&ptrTosharePrefix,prefixCount:sharePrefixArray.count)
            if (lO_sharedAccess.access != nil) {
                print("Shared Access Received")
                var ls_StringResult = try libUplinkSwiftObj.access_Serialize(accessObj:&accessResultObj.access.pointee)
                if (ls_StringResult.error != nil) {
                    print("Error while Serializing Access")
                    print("Error \n Code : ",ls_StringResult.error.pointee.code,"Message : ",String(validatingUTF8: ls_StringResult.error.pointee.message!)!)
                } else {
                    let ls_Stringkey : NSString = String(validatingUTF8: ls_StringResult.string)! as NSString
                    print("Shared String : ",ls_Stringkey)
                    print("Getting parse Access")
                    var lO_ShareAccessResult = try  libUplinkSwiftObj.parse_Access(stringKey:ls_Stringkey)
                    if (lO_ShareAccessResult.access != nil) {
                        print("Opening Project with shared Access")
                        
                        var lO_SharedProjectResult = try libUplinkSwiftObj.open_Project(ptrToAccess: &lO_ShareAccessResult.access)
                        if (lO_SharedProjectResult.project != nil) {
                           //
                            var lO_DeleteObjectResult = try libUplinkSwiftObj.delete_Object(ptrToProject: &lO_SharedProjectResult.project, bucketName: storjBucket,storjObject: storjUploadPath)
                            if (lO_DeleteObjectResult.object != nil) {
                                print("Object Deleted !!")
                                print("Object Name : ",String(validatingUTF8: lO_DeleteObjectResult.object.pointee.key!)!)
                            }else if (lO_DeleteObjectResult.error != nil) {
                                print("Failed to delete object \n Error Code : ",lO_DeleteObjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_DeleteObjectResult.error.pointee.message!)!)
                            }
                            //Free Object Result
                            try libUplinkSwiftObj.free_Object_Result(objectResultObj: &lO_DeleteObjectResult)
                            print("Closing Project Opended with share Access")
                            //Closing Project
                            var ptrToError = try libUplinkSwiftObj.close_Project(ptrToProject:&lO_SharedProjectResult.project);
                            if (ptrToError != nil) {
                                print("Failed to close project")
                                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToError)!)
                            } else {
                                print("Project Closed")
                            }
                        } else {
                            print("Failed to open project \n Error Code : ",lO_SharedProjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_SharedProjectResult.error.pointee.message!)!)
                        }
                        //Free ProjectResult
                        try libUplinkSwiftObj.free_Project_Result(projectResultObj:&lO_SharedProjectResult)
                    } else {
                        print("Shared Access \n Error Code : ",lO_ShareAccessResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_ShareAccessResult.error.pointee.message!)!)
                    }
                    //Free Access Result
                    try libUplinkSwiftObj.free_Access_Result(accessResultObj:&lO_ShareAccessResult)
                }
                //Free String Result
                try libUplinkSwiftObj.free_String_Result(StringResultObj:&ls_StringResult)
                //
            } else {
                print("Error Received while sharing Access")
                print("Error \n Code : ",lO_sharedAccess.error.pointee.code,"Message : ",String(validatingUTF8: lO_sharedAccess.error.pointee.message!)!)
            }
            //
            try libUplinkSwiftObj.free_Access_Result(accessResultObj: &lO_sharedAccess)
            
            print("Deleting Object ...")
            //Deleting Object
            var lO_DeleteObjectResult = try libUplinkSwiftObj.delete_Object(ptrToProject: &projectResultObj.project, bucketName: storjBucket,storjObject: storjUploadPath)
            if (lO_DeleteObjectResult.object != nil) {
                print("Object Deleted !!")
                print("Object Name : ",String(validatingUTF8: lO_DeleteObjectResult.object.pointee.key!)!)
            }else if (lO_DeleteObjectResult.error != nil) {
                print("Failed to delete object \n Error Code : ",lO_DeleteObjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_DeleteObjectResult.error.pointee.message!)!)
            }
            //Free Object Result
            try libUplinkSwiftObj.free_Object_Result(objectResultObj:&lO_DeleteObjectResult)
            //
            print("Deleting Bucket...")
            //Deleting empty bucket on storj
            var lO_DeleteBucketResult = try libUplinkSwiftObj.delete_Bucket(ptrToProject: &projectResultObj.project, bucketName: storjBucket)
            if (lO_DeleteBucketResult.bucket != nil) {
                print("Bucket Deleted!!")
                print("Bucket Name : ",String(validatingUTF8: lO_DeleteBucketResult.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:lO_DeleteBucketResult.bucket.pointee.created))
            } else if (lO_DeleteBucketResult.error != nil) {
                print("Failed to delete Bucket \n Error Code : ",lO_DeleteBucketResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: lO_DeleteBucketResult.error.pointee.message!)!)
            }
            //Free BucketResult
            try libUplinkSwiftObj.free_Bucket_Result(bucketResultObj:&lO_DeleteBucketResult)
            //Closing opened project
            var ptrToError = try libUplinkSwiftObj.close_Project(ptrToProject:&projectResultObj.project);
            if (ptrToError != nil) {
                print("Failed to close project")
                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToError)!)
            } else {
                print("Project Closed !! ")
            }
        } else {
            //Displaying Error
            print("Failed to get access using API Key \n Error Code : ",projectResultObj.error.pointee.code,"\n Error Message : ",String(validatingUTF8: projectResultObj.error.pointee.message!)!)
        }
        //Freeing ProjectResult
        try libUplinkSwiftObj.free_Project_Result(projectResultObj: &projectResultObj)
    } else {
        //Displaying Error
        print("Failed to get access using API Key \n Error Code : ",accessResultObj.error.pointee.code,"\n Error Message : ",String(validatingUTF8: accessResultObj.error.pointee.message!)!)
    }
    //Free AccessResult
    try libUplinkSwiftObj.free_Access_Result(accessResultObj: &accessResultObj)
} catch {
    print("Error")
    print(error)
}
//
//Function for listing object
func listBucket(libUplinkSwiftObj:inout Storj,ptrToProject:inout UnsafeMutablePointer<Project>) -> () {
    do {
        var listBucketsOptionsObj = ListBucketsOptions();
        var bucketIterator = try libUplinkSwiftObj.list_Buckets(ptrToProject: &ptrToProject, listBucketsOptionsObj: &listBucketsOptionsObj)
        if (bucketIterator != nil) {
            while (try libUplinkSwiftObj.bucket_Iterator_Next(ptrToBucketIterator: &(bucketIterator)!)) {
                var ptrTOBucket = try libUplinkSwiftObj.bucket_Iterator_Item(ptrToBucketIterator: &(bucketIterator)!)
                if (ptrTOBucket != nil) {
                    let blankString: NSString = ""
                    let ptrblankString = UnsafeMutablePointer<CChar>(mutating: blankString.utf8String)
                    print("Bucket Name : ",String(validatingUTF8: (ptrTOBucket?.pointee.name ?? ptrblankString)!)!)
                    print("Bucket Created : ",unixTimeConvert(unixTime:ptrTOBucket?.pointee.created ?? 0))
                }
                try libUplinkSwiftObj.free_Bucket(ptrToBucket:&(ptrTOBucket)!)
            }
            //
            var(ptrToError) = try  libUplinkSwiftObj.bucket_Iterator_Err(ptrToBucketIterator: &(bucketIterator)!)
            if (ptrToError != nil) {
                print("Error while listing bucket...")
                print("Error code : ",ptrToError?.pointee.code ?? 0,"\n Error message : ",String(validatingUTF8:(ptrToError?.pointee.message)!)!)
                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToError)!)
            } else {
                print("Bucket Listed Successfully !!")
            }
        }
        try libUplinkSwiftObj.free_Bucket_Iterator(ptrToBucketIterator: &(bucketIterator)!)
    } catch {
        print("Error While Listing Buckets..")
        print(error)
    }
    
}

//Uploading File
func UploadObject(libUplinkSwiftObj:inout Storj,ptrToProject:inout UnsafeMutablePointer<Project>,bucketName:NSString,localFullFileNameToUpload:NSString,storjUploadPath:NSString) -> () {
    do {
        //Checking String is empty or not
        if ((!storjUploadPath.isEqual(to: "")) && (!localFullFileNameToUpload.isEqual(to: ""))) {
            //
            let fileManager = FileManager.default
            // Check if file exits or not on localsystem
            if fileManager.fileExists(atPath: localFullFileNameToUpload as String) {
                // Checking whether file is readbale or not
                if fileManager.isReadableFile(atPath: localFullFileNameToUpload as String) {
                    // File is readable
                    let fileDetails = try fileManager.attributesOfItem(atPath: localFullFileNameToUpload as String)
                    //Size of file uploading on storj V3
                    let totalFileSizeInBytes = fileDetails[FileAttributeKey.size] as! Int
                    var totalBytesRead = 0
                    let fileHandle = FileHandle(forReadingAtPath: localFullFileNameToUpload as String)
                    if fileHandle != nil {
                        var sizeToWrite = 0
                        var lO_UploadOptions = UploadOptions()
                        let ptrToUploadOptions = UnsafeMutablePointer<UploadOptions>(&lO_UploadOptions)
                        //
                        var lO_UploadResult = try libUplinkSwiftObj.upload_Object(ptrToProject:&ptrToProject ,storjBucketName: bucketName,storjUploadPath: storjUploadPath,ptrToUploadOptions: ptrToUploadOptions)
                        //
                        let BufferSize = 1000000
                        // Reading data from the file for uploading on storj V3
                        if (lO_UploadResult.upload != nil) {
                            while (totalBytesRead<totalFileSizeInBytes) {
                                if (totalFileSizeInBytes-totalBytesRead > BufferSize) {
                                    sizeToWrite = BufferSize
                                } else {
                                    sizeToWrite = totalFileSizeInBytes-totalBytesRead
                                }
                                if(totalBytesRead>=totalFileSizeInBytes){
                                    break
                                }
                                autoreleasepool{
                                    do{
                                        let data = fileHandle?.readData(ofLength: sizeToWrite)
                                
                                        var dataInUint = [UInt8](data.map{$0}!)
                                
                                        let ptrdataInUint = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
                                        //
                                        var dataUploadedOnStorj = try  libUplinkSwiftObj.upload_Write(ptrToUpload: &lO_UploadResult.upload, ptrdataInUint: ptrdataInUint, sizeToWrite: sizeToWrite)
                                        if(dataUploadedOnStorj.error != nil){
                                            print("Failed to write on storj V3")
                                            print("Error code : ",dataUploadedOnStorj.error.pointee.code,"Error Message : ",String(validatingUTF8:(dataUploadedOnStorj.error.pointee.message)!)!)
                                        }else {
                                           totalBytesRead = totalBytesRead+Int(dataUploadedOnStorj.bytes_written)
                                        }
                                        if ((totalBytesRead>0) && (totalFileSizeInBytes>0)) {
                                            print("Data Uploaded On Storj V3 :  ",Float(totalBytesRead)/Float(totalFileSizeInBytes)*100,"%")
                                        }
                                        try libUplinkSwiftObj.free_Write_Result(writeResultObj:&dataUploadedOnStorj)
                                        dataInUint.removeAll(keepingCapacity: false)
                                    } catch {
                                        print("Error")
                                        print(error)
                                    }
                                }
                            }
                            var lO_entries = CustomMetadataEntry()
                            let keyString : NSString = "testing"
                            let ptrToKeyString = UnsafeMutablePointer<CChar>(mutating: keyString.utf8String)
                            lO_entries.key = ptrToKeyString
                            lO_entries.key_length = keyString.length
                            lO_entries.value = ptrToKeyString
                            lO_entries.value_length = keyString.length
                            let entriesArray = [lO_entries]
                            var customMetaDataObj = CustomMetadata()
                            customMetaDataObj.count = entriesArray.count
                            let ptrToentriesArray = UnsafeMutablePointer<CustomMetadataEntry>(mutating: entriesArray)
                            customMetaDataObj.entries = ptrToentriesArray
                            //
                            print("Setting Metadata")
                            let lO_SetCutomError = try libUplinkSwiftObj.upload_Set_Custom_Metadata(ptrToUpload:&lO_UploadResult.upload,customMetaDataObj:customMetaDataObj)
                            if (lO_SetCutomError != nil) {
                                print("Error while setting metadata")
                                print("Error Code : ",lO_SetCutomError?.pointee.code ?? 0,"Error Message : ",String(validatingUTF8:(lO_SetCutomError?.pointee.message)!)!)
                            } else {
                                print("Setted Custom Metadata ")
                            }
                            print("Commiting Object on Storj ")
                            var ptrToErrorObjectCommit = try  libUplinkSwiftObj.upload_Commit(ptrToUpload: &lO_UploadResult.upload)
                            //
                            if (ptrToErrorObjectCommit != nil) {
                                print("Error While Uploading Object")
                                print("Error Code : ",ptrToErrorObjectCommit?.pointee.code ?? 0,"Erro Message : ",String(validatingUTF8:(ptrToErrorObjectCommit?.pointee.message)!)!)
                                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToErrorObjectCommit)!)
                            } else {
                                print("Object Uploaded Successfully")
                            }
                            //
                            var lO_UploadInfoObject = try libUplinkSwiftObj.upload_Info(ptrToUpload:&lO_UploadResult.upload)
                            if (lO_UploadInfoObject.object != nil) {
                               print("Object Key : ",String(validatingUTF8:(lO_UploadInfoObject.object.pointee.key)!)!)
                                print("Object Created  : ",unixTimeConvert(unixTime:lO_UploadInfoObject.object.pointee.system.created))
                                print("Object Size : ",lO_UploadInfoObject.object.pointee.system.content_length)
                            } else {
                                print("Error while setting metadata")
                                print("Error Code : ",lO_UploadInfoObject.error.pointee.code,"Error Message : ",String(validatingUTF8:(lO_UploadInfoObject.error.pointee.message)!)!)
                            }
                            //
                            try libUplinkSwiftObj.free_Object_Result(objectResultObj:&lO_UploadInfoObject)
                        } else {
                           print("Error While Uploading Object")
                            print("Error Code : ",lO_UploadResult.error.pointee.code,"Error Message : ")
                        }
                        try libUplinkSwiftObj.free_Upload_Result(uploadResultObj:&lO_UploadResult)
                    }
            } else {
                print("File : ",localFullFileNameToUpload,"\n . File is not readable")
            }
        } else {
            print("File : ",localFullFileNameToUpload," \n . File does not exists. Please enter valid filename.")
        }
        } else {
            if storjUploadPath.isEqual(to: "") {
                print("Please enter valid storjPath. \n")
            }
            if localFullFileNameToUpload.isEqual(to: "") {
                print("Please enter valid filename to upload.")
            }
        }
    } catch {
        print(error)
    }
}

//Download file
func DownloadObject(libUplinkSwiftObj:inout Storj,ptrToProject:inout UnsafeMutablePointer<Project>,bucketName:NSString,localFullFileLocationToStore:NSString,storjDownloadPath:NSString) -> () {
    do {
        print("Fetching Object Info of : ",storjDownloadPath,"Bucket : ",storjDownloadPath)
        var downloadFileSizeOnStorj : Int64 = 0
        var objectResultObjInfoObject = try libUplinkSwiftObj.stat_Object(ptrToProject:&ptrToProject,bucketName:bucketName,storjObject:storjDownloadPath)
        if (objectResultObjInfoObject.object != nil) {
            print("Object Info")
            print("Object name : ",String(validatingUTF8: objectResultObjInfoObject.object.pointee.key!)!)
            print("Object size : ",objectResultObjInfoObject.object.pointee.system.content_length)
            downloadFileSizeOnStorj = objectResultObjInfoObject.object.pointee.system.content_length
            print("Object created",unixTimeConvert(unixTime:objectResultObjInfoObject.object.pointee.system.created))
        } else {
            print("Failed to fetch object Info ")
            print("Error Code : ",objectResultObjInfoObject.error.pointee.code,"Error Message : ",String(validatingUTF8:(objectResultObjInfoObject.error.pointee.message)!)!)
        }
        try libUplinkSwiftObj.free_Object_Result(objectResultObj:&objectResultObjInfoObject)
        print("Downloading ", storjDownloadPath, " Storj Object as ", localFullFileLocationToStore, " file...")
        if ((!storjDownloadPath.isEqual(to: "")) && (!localFullFileLocationToStore.isEqual(to: ""))) {
            print("Calling download function")
            var lO_DownloadOptions = DownloadOptions(offset:0,length:-1)
            let ptrToDownloadOptions = UnsafeMutablePointer<DownloadOptions>(&lO_DownloadOptions)
            var DownloadResult = try  libUplinkSwiftObj.download_Object(ptrToProject:&ptrToProject ,storjBucketName: bucketName,storjObject: storjDownloadPath,ptrToDownloadOptions: ptrToDownloadOptions)
            print("Storj Download Path : ",storjDownloadPath)
            if (DownloadResult.download != nil) {
                let fileManger = FileManager.default
                // Checking file already exits or not
                if fileManger.fileExists(atPath: localFullFileLocationToStore as String) {
                // If file exits then delete
                if fileManger.isDeletableFile(atPath: localFullFileLocationToStore as String) {
                    _ = try fileManger.removeItem(atPath: localFullFileLocationToStore as String)
                } else {
                    print ("File is not deletableFile.")
                }
            }
            if !fileManger.createFile(atPath: localFullFileLocationToStore as String, contents: nil, attributes: nil) {
                    print ("Error while creating file on local system.")
                }
                if fileManger.isWritableFile(atPath: localFullFileLocationToStore as String) {
                    let writehandel = FileHandle(forWritingAtPath: localFullFileLocationToStore as String)
                        if writehandel != nil{
                            let bufferSize = 1000000
                            let size_to_write = bufferSize
                            var download_total = 0
                            var buff = Data(capacity: bufferSize)
                            while true {
                                var receivedDataArray : [UInt8] = Array(repeating: 0, count: size_to_write)
                                let ptrtoreceivedData = receivedDataArray.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
                                var ptrToReadResult = try  libUplinkSwiftObj.download_Read(ptrToDownload: &DownloadResult.download,ptrdataInUint:ptrtoreceivedData,sizeToWrite:size_to_write)
                                if (ptrToReadResult.error == nil) {
                                    let downloadedData = ptrToReadResult.bytes_read;
                                    if downloadedData < bufferSize {
                                        receivedDataArray.removeSubrange(downloadedData..<bufferSize)
                                    }
                                    //Add data into buffer for writing into file
                                    buff.append(contentsOf: receivedDataArray)
                                    //Writing into file
                                    let _: Void? = writehandel?.write((buff))
                                    //Clearning buffer data
                                    buff.removeAll()
                                    //Total object data download from storj V3 network
                                    download_total += downloadedData
                                    if ((download_total>0) && (downloadFileSizeOnStorj>0)) {
                                        print("File Downloaded :  ",Float(download_total)/Float(downloadFileSizeOnStorj)*100,"%")
                                    }
                                    if (download_total>=downloadFileSizeOnStorj) {
                                        break
                                    }
                                    try libUplinkSwiftObj.free_Read_Result(readResultObj:&ptrToReadResult)
                             } else {
                                print("Error ")
                                break
                             }
                            }
                            if writehandel != nil {
                                writehandel?.closeFile()
                            }
                            var lO_DownloadInfoObject = try libUplinkSwiftObj.download_Info(ptrToDownload:&(DownloadResult.download)!)
                            if (lO_DownloadInfoObject.object != nil) {
                                print("Download Object Info")
                                print("Object name : ",String(validatingUTF8: lO_DownloadInfoObject.object.pointee.key!)!)
                                print("Object size : ",lO_DownloadInfoObject.object.pointee.system.content_length)
                                print("Object created on : ",unixTimeConvert(unixTime:lO_DownloadInfoObject.object.pointee.system.created))
                            } else {
                                print("Failed to get object Info")
                                print("Error Code : ",lO_DownloadInfoObject.error.pointee.code,"Error Message : ",String(validatingUTF8:(lO_DownloadInfoObject.error.pointee.message)!)!)
                            }
                            //
                            try libUplinkSwiftObj.free_Object_Result(objectResultObj:&lO_DownloadInfoObject)
                            //
                            var ptrToCloseError = try libUplinkSwiftObj.close_Download(ptrToDownload :&DownloadResult.download)
                            //
                            if (ptrToCloseError != nil) {
                                print("FAILed to download \n Error Code : ", ptrToCloseError?.pointee.code ?? 0, "Error Message")
                                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToCloseError)!)
                            } else {
                                print("Download complete")
                            }
                        }
                } else {
                    print("File is not writable")
                }
        } else {
           print("Error While Uploading Object")
            print("Error Code : ",DownloadResult.error.pointee.code,"Error Message : ")
        }
        try libUplinkSwiftObj.free_Download_Result(downloadResultObj:&DownloadResult)
        } else {
            if (storjDownloadPath.isEqual(to: "")) {
                print("Plese enter storjFullFilename for downloading object.\n")
            }
            if (localFullFileLocationToStore.isEqual(to: "")) {
                print("Please enter localFullFilename for downloading object")
            }
        }
    } catch {
        print("Error while downloading file")
        print(error)
    }
}
//Listing Objects
func ListObjects(libUplinkSwiftObj:inout Storj,ptrToProject:inout UnsafeMutablePointer<Project>,bucketName:NSString) -> () {
    do {
        var listObjectsOptionsObj = ListObjectsOptions();
        listObjectsOptionsObj.recursive = true
        var prefix: NSString = "change-me-to-desired-object-prefix"
        let ptrToPrefix = UnsafeMutablePointer<CChar>(mutating: prefix.utf8String)
        listObjectsOptionsObj.prefix = ptrToPrefix
        var objectIterator = try  libUplinkSwiftObj.list_Objects(ptrToProject: &ptrToProject,storjBucketName:bucketName, listObjectsOptionsObj: &listObjectsOptionsObj)
        if (objectIterator != nil) {
            while (try libUplinkSwiftObj.object_Iterator_Next(ptrToObjectIterator: &(objectIterator)!)) {
                var ptrToObject = try libUplinkSwiftObj.object_Iterator_Item(ptrToObjectIterator: &(objectIterator)!)
            if (ptrToObject != nil) {
                print("Object Info")
                print("Object Name : ",String(validatingUTF8:(ptrToObject?.pointee.key)!)!)
                try libUplinkSwiftObj.free_Object(ptrToObject:&(ptrToObject)!)
            }
        }
            var ptrToError = try  libUplinkSwiftObj.object_Iterator_Err(ptrToObjectIterator: &(objectIterator)!)
            //print(ptrToError ?? nil )
            if (ptrToError != nil) {
            print("Error while listing object...")
            print("Error code : ",ptrToError?.pointee.code ?? 0,"\n Error message : ",String(validatingUTF8:(ptrToError?.pointee.message)!)!)
                try libUplinkSwiftObj.free_Error(ptrToError:&(ptrToError)!)
        } else {
            print("Object Listed Successfully !!")
        }
        }
        try libUplinkSwiftObj.free_Object_Iterator(ptrToObjectIterator:&(objectIterator)!)
    } catch {
        print(error)
    }
}
