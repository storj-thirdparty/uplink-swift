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
//Storj("change-me-to-dylib-location") if not provided then default path will be storj-swift/Sources/ClibUplink/include
//for example Storj("locationWhereStorjSwiftIsDownload/Sources/ClibUplink/include/libuplinkc.dylib")
var storjSwift = Storj("")
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
    var accessResult = try storjSwift.request_Access_With_Passphrase(satelliteAddress: storjSatellite, apiKey: storjApiKey, encryptionPassphrase: storjEncryptionPassphrase);
    //Checking Whether Error or Access is return.
    if (accessResult.access != nil) {
        print("Access granted !!")
        print("Opening project on storj V3 network.....")
        var projectResult = try storjSwift.open_Project(access: &accessResult.access)
        //
        if (projectResult.project != nil) {
            print("\nGetting info about bucket : ",storjBucket)
            //
            var bucketResult = try storjSwift.stat_Bucket(project: &projectResult.project, bucketName: storjBucket)
            //
            if (bucketResult.bucket != nil) {
                print("Bucket Information \nBucket created : ",unixTimeConvert(unixTime: bucketResult.bucket.pointee.created),"Bucket Name : ",String(validatingUTF8:bucketResult.bucket.pointee.name!)!)
            }else if (bucketResult.error != nil) {
                print("Failed to get information about Bucket \n Error Code : ",bucketResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: bucketResult.error.pointee.message!)!)
            }
            //
            try storjSwift.free_Bucket_Result(bucketResult: &bucketResult)
            //
            print("\nCreating Bucket : ",storjBucket)
            //
            var CreateBucketResultObj = try  storjSwift.create_Bucket(project: &projectResult.project, bucketName: storjBucket)
            //
            if (CreateBucketResultObj.bucket != nil) {
               print("Bucket Created !!")
                print("Bucket Name : ",String(validatingUTF8: CreateBucketResultObj.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:CreateBucketResultObj.bucket.pointee.created))
            } else {
                print("Failed to create Bucket Bucket \n Error Code : ",CreateBucketResultObj.error.pointee.code,"\n Error Message : ",String(validatingUTF8: CreateBucketResultObj.error.pointee.message!)!)
            }
            try storjSwift.free_Bucket_Result(bucketResult: &CreateBucketResultObj)
            //
            print("\nGetting info of created bucket")
            var ensureBucketResult = try  storjSwift.ensure_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if (ensureBucketResult.bucket != nil) {
                print("Bucket Name : ",String(validatingUTF8: ensureBucketResult.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:ensureBucketResult.bucket.pointee.created))
            } else {
                print("Failed to get information of Bucket \n Error Code : ",ensureBucketResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: ensureBucketResult.error.pointee.message!)!)
            }
            //
            try storjSwift.free_Bucket_Result(bucketResult: &ensureBucketResult)
            //
            print("\n\nListing Buckets...")
            listBucket( storjSwift:&storjSwift,project: &projectResult.project)
            //
            print("\n\nUploading Object...")
            UploadObject( storjSwift:&storjSwift,project: &projectResult.project, bucketName: storjBucket,localFullFileNameToUpload:localFullFileNameToUpload,storjUploadPath:storjUploadPath)
            //
            print("\n\nDownloading Object...")
            DownloadObject(storjSwift:&storjSwift,project: &projectResult.project, bucketName: storjBucket,localFullFileLocationToStore:localFullFileLocationToStore,storjDownloadPath:storjDownloadPath)
            //
            print("\n\nListing Object")
            ListObjects(storjSwift:&storjSwift,project: &projectResult.project,bucketName:storjBucket)
            //
            print("Creating Share Access")
            var permission = Permission()
            permission.allow_delete = true
            permission.allow_upload = true
            var sharePrefix = SharePrefix()
            let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucket.utf8String)
            let objectPrefix : NSString = "change-me-to-desired-object-prefix";
            let prefix = UnsafeMutablePointer<CChar>(mutating: objectPrefix.utf8String)
            sharePrefix.bucket = ptrToBucketName
            sharePrefix.prefix = prefix
            let sharePrefixArray = [sharePrefix]
            var ptrTosharePrefix = UnsafeMutablePointer<SharePrefix>(mutating: sharePrefixArray)
            var sharedAccess = try storjSwift.access_Share(access: &accessResult.access,permission:&permission,prefix:&ptrTosharePrefix,prefixCount:sharePrefixArray.count)
            if (sharedAccess.access != nil) {
                print("Shared Access Received")
                var stringResult = try storjSwift.access_Serialize(access:&accessResult.access.pointee)
                if (stringResult.error != nil) {
                    print("Error while Serializing Access")
                    print("Error \n Code : ",stringResult.error.pointee.code,"Message : ",String(validatingUTF8: stringResult.error.pointee.message!)!)
                } else {
                    let stringKey : NSString = String(validatingUTF8: stringResult.string)! as NSString
                    print("Shared String : ",stringKey)
                    print("Getting parse Access")
                    var shareAccessResult = try  storjSwift.parse_Access(stringKey:stringKey)
                    if (shareAccessResult.access != nil) {
                        print("Opening Project with shared Access")
                        
                        var sharedProjectResult = try storjSwift.open_Project(access: &shareAccessResult.access)
                        if (sharedProjectResult.project != nil) {
                           //
                            var deleteObjectResult = try storjSwift.delete_Object(project: &sharedProjectResult.project, bucketName: storjBucket,storjObjectName: storjUploadPath)
                            if (deleteObjectResult.object != nil) {
                                print("Object Deleted !!")
                                print("Object Name : ",String(validatingUTF8: deleteObjectResult.object.pointee.key!)!)
                            }else if (deleteObjectResult.error != nil) {
                                print("Failed to delete object \n Error Code : ",deleteObjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: deleteObjectResult.error.pointee.message!)!)
                            }
                            //Free Object Result
                            try storjSwift.free_Object_Result(objectResult: &deleteObjectResult)
                            print("Closing Project Opended with share Access")
                            //Closing Project
                            var error = try storjSwift.close_Project(project:&sharedProjectResult.project);
                            if (error != nil) {
                                print("Failed to close project")
                                try storjSwift.free_Error(error:&(error)!)
                            } else {
                                print("Project Closed")
                            }
                        } else {
                            print("Failed to open project \n Error Code : ",sharedProjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: sharedProjectResult.error.pointee.message!)!)
                        }
                        //Free ProjectResult
                        try storjSwift.free_Project_Result(projectResult:&sharedProjectResult)
                    } else {
                        print("Shared Access \n Error Code : ",shareAccessResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: shareAccessResult.error.pointee.message!)!)
                    }
                    //Free Access Result
                    try storjSwift.free_Access_Result(accessResult:&shareAccessResult)
                }
                //Free String Result
                try storjSwift.free_String_Result(stringResult:&stringResult)
                //
            } else {
                print("Error Received while sharing Access")
                print("Error \n Code : ",sharedAccess.error.pointee.code,"Message : ",String(validatingUTF8: sharedAccess.error.pointee.message!)!)
            }
            //
            try storjSwift.free_Access_Result(accessResult: &sharedAccess)
            
            print("Deleting Object ...")
            //Deleting Object
            var deleteObjectResult = try storjSwift.delete_Object(project: &projectResult.project, bucketName: storjBucket,storjObjectName: storjUploadPath)
            if (deleteObjectResult.object != nil) {
                print("Object Deleted !!")
                print("Object Name : ",String(validatingUTF8: deleteObjectResult.object.pointee.key!)!)
            }else if (deleteObjectResult.error != nil) {
                print("Failed to delete object \n Error Code : ",deleteObjectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: deleteObjectResult.error.pointee.message!)!)
            }
            //Free Object Result
            try storjSwift.free_Object_Result(objectResult:&deleteObjectResult)
            //
            print("Deleting Bucket...")
            //Deleting empty bucket on storj
            var deleteBucketResult = try storjSwift.delete_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if (deleteBucketResult.bucket != nil) {
                print("Bucket Deleted!!")
                print("Bucket Name : ",String(validatingUTF8: deleteBucketResult.bucket.pointee.name!)!)
                print("Bucket Created : ",unixTimeConvert(unixTime:deleteBucketResult.bucket.pointee.created))
            } else if (deleteBucketResult.error != nil) {
                print("Failed to delete Bucket \n Error Code : ",deleteBucketResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: deleteBucketResult.error.pointee.message!)!)
            }
            //Free BucketResult
            try storjSwift.free_Bucket_Result(bucketResult:&deleteBucketResult)
            //Closing opened project
            var error = try storjSwift.close_Project(project:&projectResult.project);
            if (error != nil) {
                print("Failed to close project")
                try storjSwift.free_Error(error:&(error)!)
            } else {
                print("Project Closed !! ")
            }
        } else {
            //Displaying Error
            print("Failed to get access using API Key \n Error Code : ",projectResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: projectResult.error.pointee.message!)!)
        }
        //Freeing ProjectResult
        try storjSwift.free_Project_Result(projectResult: &projectResult)
    } else {
        //Displaying Error
        print("Failed to get access using API Key \n Error Code : ",accessResult.error.pointee.code,"\n Error Message : ",String(validatingUTF8: accessResult.error.pointee.message!)!)
    }
    //Free AccessResult
    try storjSwift.free_Access_Result(accessResult: &accessResult)
} catch {
    print("Error")
    print(error)
}
//
//Function for listing object
func listBucket(storjSwift:inout Storj,project:inout UnsafeMutablePointer<Project>) -> () {
    do {
        var listBucketsOptionsObj = ListBucketsOptions();
        var bucketIterator = try storjSwift.list_Buckets(project: &project, listBucketsOptionsObj: &listBucketsOptionsObj)
        if (bucketIterator != nil) {
            while (try storjSwift.bucket_Iterator_Next(bucketIterator: &(bucketIterator)!)) {
                var bucket = try storjSwift.bucket_Iterator_Item(bucketIterator: &(bucketIterator)!)
                if (bucket != nil) {
                    let blankString: NSString = ""
                    let ptrblankString = UnsafeMutablePointer<CChar>(mutating: blankString.utf8String)
                    print("Bucket Name : ",String(validatingUTF8: (bucket?.pointee.name ?? ptrblankString)!)!)
                    print("Bucket Created : ",unixTimeConvert(unixTime:bucket?.pointee.created ?? 0))
                }
                try storjSwift.free_Bucket(bucket:&(bucket)!)
            }
            //
            var(error) = try  storjSwift.bucket_Iterator_Err(bucketIterator: &(bucketIterator)!)
            if (error != nil) {
                print("Error while listing bucket...")
                print("Error code : ",error?.pointee.code ?? 0,"\n Error message : ",String(validatingUTF8:(error?.pointee.message)!)!)
                try storjSwift.free_Error(error:&(error)!)
            } else {
                print("Bucket Listed Successfully !!")
            }
        }
        try storjSwift.free_Bucket_Iterator(bucketIterator: &(bucketIterator)!)
    } catch {
        print("Error While Listing Buckets..")
        print(error)
    }
    
}

//Uploading File
func UploadObject(storjSwift:inout Storj,project:inout UnsafeMutablePointer<Project>,bucketName:NSString,localFullFileNameToUpload:NSString,storjUploadPath:NSString) -> () {
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
                        var uploadOptions = UploadOptions()
                        let ptrUploadOptions = UnsafeMutablePointer<UploadOptions>(&uploadOptions)
                        //
                        var uploadResult = try storjSwift.upload_Object(project:&project ,storjBucketName: bucketName,storjUploadPath: storjUploadPath,uploadOptions: ptrUploadOptions)
                        //
                        let BufferSize = 1000000
                        // Reading data from the file for uploading on storj V3
                        if (uploadResult.upload != nil) {
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
                                
                                        let dataBuffer = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
                                        //
                                        var dataUploadedOnStorj = try  storjSwift.upload_Write(upload: &uploadResult.upload, data: dataBuffer, sizeToWrite: sizeToWrite)
                                        if(dataUploadedOnStorj.error != nil){
                                            print("Failed to write on storj V3")
                                            print("Error code : ",dataUploadedOnStorj.error.pointee.code,"Error Message : ",String(validatingUTF8:(dataUploadedOnStorj.error.pointee.message)!)!)
                                        }else {
                                           totalBytesRead = totalBytesRead+Int(dataUploadedOnStorj.bytes_written)
                                        }
                                        if ((totalBytesRead>0) && (totalFileSizeInBytes>0)) {
                                            print("Data Uploaded On Storj V3 :  ",Float(totalBytesRead)/Float(totalFileSizeInBytes)*100,"%")
                                        }
                                        try storjSwift.free_Write_Result(writeResult:&dataUploadedOnStorj)
                                        dataInUint.removeAll(keepingCapacity: false)
                                    } catch {
                                        print("Error")
                                        print(error)
                                    }
                                }
                            }
                            var entries = CustomMetadataEntry()
                            let keyString : NSString = "testing"
                            let ptrToKeyString = UnsafeMutablePointer<CChar>(mutating: keyString.utf8String)
                            entries.key = ptrToKeyString
                            entries.key_length = keyString.length
                            entries.value = ptrToKeyString
                            entries.value_length = keyString.length
                            let entriesArray = [entries]
                            var customMetaDataObj = CustomMetadata()
                            customMetaDataObj.count = entriesArray.count
                            let ptrToEntriesArray = UnsafeMutablePointer<CustomMetadataEntry>(mutating: entriesArray)
                            customMetaDataObj.entries = ptrToEntriesArray
                            //
                            print("Setting Metadata")
                            let setCutomMetaDataResult = try storjSwift.upload_Set_Custom_Metadata(upload:&uploadResult.upload,customMetaDataObj:customMetaDataObj)
                            if (setCutomMetaDataResult != nil) {
                                print("Error while setting metadata")
                                print("Error Code : ",setCutomMetaDataResult?.pointee.code ?? 0,"Error Message : ",String(validatingUTF8:(setCutomMetaDataResult?.pointee.message)!)!)
                            } else {
                                print("Setted Custom Metadata ")
                            }
                            print("Commiting Object on Storj ")
                            var ptrToErrorObjectCommit = try  storjSwift.upload_Commit(upload: &uploadResult.upload)
                            //
                            if (ptrToErrorObjectCommit != nil) {
                                print("Error While Uploading Object")
                                print("Error Code : ",ptrToErrorObjectCommit?.pointee.code ?? 0,"Erro Message : ",String(validatingUTF8:(ptrToErrorObjectCommit?.pointee.message)!)!)
                                try storjSwift.free_Error(error:&(ptrToErrorObjectCommit)!)
                            } else {
                                print("Object Uploaded Successfully")
                            }
                            //
                            var uploadObjectInfo = try storjSwift.upload_Info(upload:&uploadResult.upload)
                            if (uploadObjectInfo.object != nil) {
                               print("Object Key : ",String(validatingUTF8:(uploadObjectInfo.object.pointee.key)!)!)
                                print("Object Created  : ",unixTimeConvert(unixTime:uploadObjectInfo.object.pointee.system.created))
                                print("Object Size : ",uploadObjectInfo.object.pointee.system.content_length)
                            } else {
                                print("Error while setting metadata")
                                print("Error Code : ",uploadObjectInfo.error.pointee.code,"Error Message : ",String(validatingUTF8:(uploadObjectInfo.error.pointee.message)!)!)
                            }
                            //
                            try storjSwift.free_Object_Result(objectResult:&uploadObjectInfo)
                        } else {
                           print("Error While Uploading Object")
                            print("Error Code : ",uploadResult.error.pointee.code,"Error Message : ")
                        }
                        try storjSwift.free_Upload_Result(uploadResult:&uploadResult)
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
func DownloadObject(storjSwift:inout Storj,project:inout UnsafeMutablePointer<Project>,bucketName:NSString,localFullFileLocationToStore:NSString,storjDownloadPath:NSString) -> () {
    do {
        print("Fetching Object Info of : ",storjDownloadPath,"Bucket : ",storjDownloadPath)
        var downloadFileSizeOnStorj : Int64 = 0
        var objectResultObjInfoObject = try storjSwift.stat_Object(project:&project,bucketName:bucketName,storjObjectName:storjDownloadPath)
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
        try storjSwift.free_Object_Result(objectResult:&objectResultObjInfoObject)
        print("Downloading ", storjDownloadPath, " Storj Object as ", localFullFileLocationToStore, " file...")
        if ((!storjDownloadPath.isEqual(to: "")) && (!localFullFileLocationToStore.isEqual(to: ""))) {
            print("Calling download function")
            var downloadOptions = DownloadOptions(offset:0,length:-1)
            let ptrDownloadOptions = UnsafeMutablePointer<DownloadOptions>(&downloadOptions)
            var DownloadResult = try  storjSwift.download_Object(project:&project ,storjBucketName: bucketName,storjObjectName: storjDownloadPath,downloadOptions: ptrDownloadOptions)
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
                                var ptrToReadResult = try  storjSwift.download_Read(download: &DownloadResult.download,data:ptrtoreceivedData,sizeToWrite:size_to_write)
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
                                    try storjSwift.free_Read_Result(readResult:&ptrToReadResult)
                             } else {
                                print("Error ")
                                break
                             }
                            }
                            if writehandel != nil {
                                writehandel?.closeFile()
                            }
                            var downloadObjectInfo = try storjSwift.download_Info(download:&(DownloadResult.download)!)
                            if (downloadObjectInfo.object != nil) {
                                print("Download Object Info")
                                print("Object name : ",String(validatingUTF8: downloadObjectInfo.object.pointee.key!)!)
                                print("Object size : ",downloadObjectInfo.object.pointee.system.content_length)
                                print("Object created on : ",unixTimeConvert(unixTime:downloadObjectInfo.object.pointee.system.created))
                            } else {
                                print("Failed to get object Info")
                                print("Error Code : ",downloadObjectInfo.error.pointee.code,"Error Message : ",String(validatingUTF8:(downloadObjectInfo.error.pointee.message)!)!)
                            }
                            //
                            try storjSwift.free_Object_Result(objectResult:&downloadObjectInfo)
                            //
                            var ptrToCloseError = try storjSwift.close_Download(download :&DownloadResult.download)
                            //
                            if (ptrToCloseError != nil) {
                                print("FAILed to download \n Error Code : ", ptrToCloseError?.pointee.code ?? 0, "Error Message")
                                try storjSwift.free_Error(error:&(ptrToCloseError)!)
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
        try storjSwift.free_Download_Result(downloadResult:&DownloadResult)
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
func ListObjects(storjSwift:inout Storj,project:inout UnsafeMutablePointer<Project>,bucketName:NSString) -> () {
    do {
        var listObjectsOptions = ListObjectsOptions();
        listObjectsOptions.recursive = true
        var prefix: NSString = "change-me-to-desired-object-prefix"
        let ptrPrefix = UnsafeMutablePointer<CChar>(mutating: prefix.utf8String)
        listObjectsOptions.prefix = ptrPrefix
        var objectIterator = try  storjSwift.list_Objects(project: &project,storjBucketName:bucketName, listObjectsOptions: &listObjectsOptions)
        if (objectIterator != nil) {
            while (try storjSwift.object_Iterator_Next(objectIterator: &(objectIterator)!)) {
                var object = try storjSwift.object_Iterator_Item(objectIterator: &(objectIterator)!)
            if (object != nil) {
                print("Object Info")
                print("Object Name : ",String(validatingUTF8:(object?.pointee.key)!)!)
                try storjSwift.free_Object(object:&(object)!)
            }
        }
            var error = try  storjSwift.object_Iterator_Err(objectIterator: &(objectIterator)!)
            //print(error ?? nil )
            if (error != nil) {
            print("Error while listing object...")
            print("Error code : ",error?.pointee.code ?? 0,"\n Error message : ",String(validatingUTF8:(error?.pointee.message)!)!)
                try storjSwift.free_Error(error:&(error)!)
        } else {
            print("Object Listed Successfully !!")
        }
        }
        try storjSwift.free_Object_Iterator(objectIterator:&(objectIterator)!)
    } catch {
        print(error)
    }
}
