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
var storjApiKey : NSString = "change-me-to-the-api-key-created-in-satellite-gui"
// Satellite address
var storjSatellite : NSString = "us-central-1.tardigrade.io:7777"
// Encryption passphrase
var storjEncryptionPassphrase : NSString = "you'll never guess this"
// Bucket name
var storjBucket : NSString = "change-me-to-desired-bucket-name"
//
// Upload path within the bucket, whereto the sample message is to be uploaded.
var storjUploadPath : NSString = "optionalpath/requiredfilename"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath : NSString = "optionalpath/requiredfilename"

// Full file name, including path, of the local system, to be uploaded to Storj bucket.
var localFullFileNameToUpload : NSString = "optionalpath/requiredfilename"
// Local full path, where the Storj object is to be stored after download.
var localFullFileLocationToStore : NSString = "optionalpath/requiredfilename"

// Storj full filename for deleting object
var storjDeleteObject : NSString = "optionalpath/requiredfilename"
// Storj bucekt name for deleting empty bucket
var storjDeleteBucket : NSString = "hange-me-to-desired-bucket-name"

// Create an object of the Storj-Swift bindings, so as to access functions.
var lO_libUplinkSwift = libUplinkSwift("")

print("Setting-up a New Uplink...")
// Create a new uplink.
// Create an object of the Storj-Swift bindings, so as to access functions.
let (lO_uplinkRef, uplinkError) = lO_libUplinkSwift.Uplink()
//
if uplinkError == "" {
    print("New Uplink: SET-UP!\nParsing the API Key: ", storjApiKey)
    //
    let (lO_parseAPIKeyRef, parseAPIKeyError) = lO_libUplinkSwift.parseAPIKey(apiKey: storjApiKey)
    //
    if parseAPIKeyError == "" {
        print("API key: PARSED!\nOpening the Storj Project from Satellite: ", storjSatellite)
        //
        let (lO_ProjectRef, openProjectError) = lO_libUplinkSwift.openProject(uplinkRef: lO_uplinkRef, satellite: storjSatellite, parsedAPIRef: lO_parseAPIKeyRef)
        //
        
        if openProjectError == "" {
            print("Desired Storj Project: OPENED!\nCreating a new bucket with name, ", storjBucket, " ...")
            //
            let (lO_BucketInfo, createBucketError) = lO_libUplinkSwift.createBucket(lO_projectRef: lO_ProjectRef, bucketName: storjBucket)
            //
            if createBucketError != "" {
                print("FAILed to create a new bucket!")
                print(createBucketError)
            } else {
                print("New Bucket: CREATED!")
            }
            
            // Listing bucket
            print("Listing Buckets...")
            //
            var lO_BucketListOptions = BucketListOptions()
            //
            var (lO_BucketList, bucketListError) = lO_libUplinkSwift.listBuckets(lO_ProjectRef: lO_ProjectRef, lO_BucketListOption: &lO_BucketListOptions)
            //
            if bucketListError.isEqual(to: "") {
                if lO_BucketList.length-1 > 0 {
                    print("Sl.No\t Bucket Name \t\t\t\t\t\t Bucket created")
                    for index in 0...lO_BucketList.length-1 {
                        var bucketName :NSString = ""
                        //
                        let unixdate = lO_BucketList.items?[Int(index)].created
                        //
                        if let bucketNameCstring = lO_BucketList.items?[Int(index)].name {
                            bucketName = String(cString: bucketNameCstring) as NSString
                        }
                        print(index+1,"\t\t",bucketName,"\t\t\t\t\t\t",unixdate)
                    }
                }
            } else {
                print("FAILed to list buckets!")
                print(bucketListError)
            }
            
            // free the memory , dynamically allocated by the c library
            var lO_BuckeListPtr = UnsafeMutablePointer<BucketList>(&lO_BucketList)
            //
            var errorFreeBucketList = lO_libUplinkSwift.freeBucketList(bucketListPtr: lO_BuckeListPtr)
            //
            if !errorFreeBucketList.isEqual(to: "") {
                print("FAILed to free bucket list")
            } else {
                print("Freed bucket List !")
            }
            
            //
            print("Accessing given Encryption Phasshrase...")
            //
            let (ptrSerializedAccess, encryptionKeyError) = lO_libUplinkSwift.getEncryptionAccess(lO_ProjectRef: lO_ProjectRef, encryptionPassphrase: storjEncryptionPassphrase)
            //
            if ptrSerializedAccess != nil {
                //
                print("Encryption Access: RECEIVED!\nOpening ", storjBucket, " Bucket...")
                //
                
                let (lO_OpenBucket, openBucketError) = lO_libUplinkSwift.openBucket(lO_ProjectRef: lO_ProjectRef, bucketName: storjBucket, ptrSerialAccess: ptrSerializedAccess)
                
                
                if openBucketError == "" {
                    print(storjBucket, " Bucket: OPENED!", "\nUploading ", localFullFileNameToUpload, "file to the Storj Bucket...")
                    // as an example of 'put' , lets read and upload a local file
                    
                    if ((!storjUploadPath.isEqual(to: "")) && (!localFullFileNameToUpload.isEqual(to: ""))) {
                        let fileManger = FileManager.default
                        // Check if file exits or not on localsystem
                        if fileManger.fileExists(atPath: localFullFileNameToUpload as String) {
                            // If file is readable or not
                           if fileManger.isReadableFile(atPath: localFullFileNameToUpload as String) {
                            // File is readable
                            do {
                                let fileDetails = try fileManger.attributesOfItem(atPath: localFullFileNameToUpload as String)
                                //
                                let totalFileSizeInBytes = fileDetails[FileAttributeKey.size] as! Int
                                //
                                var totalBytesRead = 0;
                                //
                                let fileHandle = FileHandle(forReadingAtPath: localFullFileNameToUpload as String)
                                //
                                if fileHandle != nil {
                                    //
                                    var sizeToWrite = 0
                                    //
                                    let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
                                    //
                                    var lO_uploadOption = UploadOptions()
                                    //
                                    lO_uploadOption.expires = 1569709908
                                    //
                                    let lO_uploadPathPtr = UnsafeMutablePointer<UploadOptions>(&lO_uploadOption)
                                    //
                                    print("Calling Upload function")
                                    //
                                    let (lO_Uploader,uploaderError) = lO_libUplinkSwift.Upload(lO_bucketRef: lO_OpenBucket, storjUploadPath: storjUploadPath, localFullFileNameToUpload: localFullFileNameToUpload, lO_uploadPathPtr :lO_uploadPathPtr)
                                    
                                    if !uploaderError.isEqual(to: "") {
                                        //
                                        print("FAILed to create uploader \nstorjUploadpath : ",storjUploadPath,"\nlocalFullFilename to upload :",localFullFileNameToUpload)
                                        //
                                        print(uploaderError)
                                        
                                    } else {
                                        while (totalBytesRead<totalFileSizeInBytes) {
                                                if (totalFileSizeInBytes-totalBytesRead > 256) {
                                                    sizeToWrite = 256
                                                } else {
                                                    sizeToWrite = totalFileSizeInBytes-totalBytesRead
                                                }
                                                if sizeToWrite == 0 {
                                                    break
                                                }
                                                // Reading data from the file for uploading on storj V3
                                                let data = fileHandle?.readData(ofLength: sizeToWrite)
                                                //
                                                var dataInUint = [UInt8](data.map{$0}!)
                                                //
                                                let ptrdataInUint = UnsafeMutablePointer<UInt8>(&dataInUint)
                                                //
                                                var (dataUploadedOnStorj, uploadWriterError) = lO_libUplinkSwift.UploadWrite(uploaderRef: lO_Uploader, ptrdataInUint: ptrdataInUint, sizeToWrite: sizeToWrite)
                                                if uploadWriterError != "" {
                                                    print(uploadWriterError)
                                                    break
                                                }
                                                //
                                                totalBytesRead += sizeToWrite
                                            }
                                            print("Calling upload commit function")
                                            let uploadCommitError = lO_libUplinkSwift.UploadCommit(uploaderRef: lO_Uploader)
                                                
                                            if uploadCommitError != "" {
                                                print("Error recieved by commiting upload")
                                                print(uploaderError)
                                            } else {
                                                
                                                print(localFullFileNameToUpload, " FILE : UPLOADED as ", storjUploadPath, " file...")
                                                print("Downloading ", storjDownloadPath, " Storj Object as ", localFullFileLocationToStore, " file...")
                                                
                                                if((!storjDownloadPath.isEqual(to: "")) && (!localFullFileLocationToStore.isEqual(to: ""))) {
                                                    //
                                                    print("Calling download function")
                                                    //
                                                    let (lO_downloader,downloaderError) = lO_libUplinkSwift.Download(lO_bucketRef : lO_OpenBucket,storjFullFilename : storjDownloadPath)
                                                    if downloaderError.isEqual(to: "") {
                                                        let fileManger = FileManager.default
                                                        // Checking file already exits or not
                                                        if fileManger.fileExists(atPath: localFullFileLocationToStore as String) {
                                                        // If file exits then delete
                                                        if fileManger.isDeletableFile(atPath: localFullFileLocationToStore as String) {
                                                            do {
                                                                 var result = try fileManger.removeItem(atPath: localFullFileLocationToStore as String)
                                                            } catch {
                                                                    print ("Error while deleting already existing file.")
                                                                }
                                                            } else {
                                                                print ("File is not deletableFile.")
                                                            }
                                                            if !fileManger.createFile(atPath: localFullFileLocationToStore as String, contents: nil, attributes: nil) {
                                                                print ("Error while creating file on local system.")
                                                            }
                                                            if fileManger.isWritableFile(atPath: localFullFileLocationToStore as String) {
                                                                var writehandel = FileHandle(forWritingAtPath: localFullFileLocationToStore as String)
                                                                //
                                                                if writehandel != nil{
                                                                    //
                                                                    let size_to_write = 256
                                                                    //
                                                                    var download_total = 0
                                                                    //
                                                                    var buff = Data(capacity: 256)
                                                                    //
                                                                    while true {
                                                                    //
                                                                    var sizeOfFile = 256
                                                                    //
                                                                    var receivedDataArray : [UInt8] = Array(repeating: 0, count: size_to_write)
                                                                    //
                                                                    let ptrtoreceivedData = UnsafeMutablePointer<UInt8>(&receivedDataArray)
                                                                    //
                                                                    var (downloadedData,downReaderError) = lO_libUplinkSwift.downloadRead(lO_downloader: lO_downloader, ptrtoreceivedData: ptrtoreceivedData, size_to_write: sizeToWrite)
                                                                        if downloadedData == 0 {
                                                                            break
                                                                        }
                                                                        if downloadedData < 256 {
                                                                                receivedDataArray.removeSubrange(downloadedData..<256)
                                                                        }
                                                                        
                                                                        if downloaderError != "" {
                                                                            print(downloaderError)
                                                                            break
                                                                        }
                                                                        download_total += size_to_write
                                                                        //
                                                                        buff.append(contentsOf: receivedDataArray)
                                                                        //
                                                                        var resultwrite = writehandel?.write((buff))
                                                                        //
                                                                        buff.removeAll()
                                                                    }
                                                                    //
                                                                    if writehandel != nil{
                                                                        writehandel?.closeFile()
                                                                    }
                                                                    var downloadCloseError = lO_libUplinkSwift.downloadClose(lO_downloader :lO_downloader)
                                                                    if downloadCloseError != "" {
                                                                         print("FAILed to download ", localFullFileLocationToStore, "object from the storj bucket")
                                                                        print(downloadCloseError)
                                                                    } else {
                                                                        print("Download complete")
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        }
                                                
                                                        
                                                    } else {
                                                        print(downloaderError)
                                                    }
                                                }else {
                                                    if (storjDownloadPath.isEqual(to: "")) {
                                                        print("Plese enter storjFullFilename for downloading object.\n")
                                                        
                                                    }
                                                    if (localFullFileLocationToStore.isEqual(to: "")) {
                                                        print("Please enter localFullFilename for downloading object")
                                                    }
                                                }
                                                //print("Calling Download function")
                                            }
                                        }
                                    } else {
                                        print("file handle nil")
                                }
                            } catch {
                                print("Error while reading filesize.")
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
                    print("Listing Objects without prefix")
                    //
                    var lO_ListOption = ListOptions()
                    //
                    let blank : NSString = ""
                    //
                    var ptrToblank = UnsafeMutablePointer<CChar>(mutating: blank.utf8String)
                    //
                    lO_ListOption.prefix = ptrToblank
                    lO_ListOption.cursor = ptrToblank
                    lO_ListOption.delimiter = (Int8(" ") ?? 32)!
                    lO_ListOption.recursive = false
                    lO_ListOption.direction = ListDirection(rawValue: 1)
                    lO_ListOption.limit = 0
                    
                    var (lO_ObjectList,listObjectError) = lO_libUplinkSwift.listObjects(lO_bucketRef: lO_OpenBucket,lO_ListOption: &lO_ListOption)
                     //
                    if listObjectError != "" {
                        print("FAILed to list Object")
                        print(listObjectError)
                        
                    } else {
                        
                        if lO_ObjectList.length > 0 {
                            print("Sl.No\t Object Name\t\t\t\t\t\t Created")
                            for index in 0...lO_ObjectList.length-1 {
                                var objectName :NSString = ""
                                //
                                let unixdate = lO_ObjectList.items?[Int(index)].created
                                //
                                if let objectString = lO_ObjectList.items?[Int(index)].path {
                                    objectName = String(cString: objectString) as NSString
                                }
                                print(index+1,"\t\t",objectName,"\t\t\t\t\t\t",unixdate)
                            }
                        }
                        let objectListPtr = UnsafeMutablePointer<ObjectList>(&lO_ObjectList)
                        //
                        lO_libUplinkSwift.freeObjectList(objectListPointer: objectListPtr)
                    }
                    //
                    print("Listing Object with prefix")
                    //
                    let prefix : NSString = "path"
                    //
                    var ptrToPrefix = UnsafeMutablePointer<CChar>(mutating: prefix.utf8String)
                    //
                    lO_ListOption.prefix = ptrToPrefix
                    (lO_ObjectList,listObjectError) = lO_libUplinkSwift.listObjects(lO_bucketRef: lO_OpenBucket,lO_ListOption: &lO_ListOption)
                    //
                    if listObjectError != "" {
                      print("FAILed to list bucket with object")
                      print(listObjectError)
                    } else {
                        if lO_ObjectList.length > 0 {
                            print("Sl.No\t Object Name\t\t\t\t\t\t Created")
                            for index in 0...lO_ObjectList.length-1 {
                                var objectName :NSString = ""
                                //
                                let unixdate = lO_ObjectList.items?[Int(index)].created
                                //
                                if let errorCstring = lO_ObjectList.items?[Int(index)].path {
                                    objectName = String(cString: errorCstring) as NSString
                                }
                                print(index+1,"\t",objectName,"\t\t\t\t\t\t",unixdate)
                            }
                    
                        }
                        var objectListPtr = UnsafeMutablePointer<ObjectList>(&lO_ObjectList)
                        //
                        lO_libUplinkSwift.freeObjectList(objectListPointer: objectListPtr)
                        
                    }
                    //
                    
                    print("\nDeleting Object\n")
                    //
                    var deleteObjectError = lO_libUplinkSwift.deleteObject(lO_bucketRef: lO_OpenBucket, storjObjectPath: storjUploadPath)
                    //
                    if deleteObjectError.isEqual(to: "") {
                        print("Object :",storjUploadPath,"sucessfully deleted ")
                    } else {
                        print("FAILed to delete Object : ",storjUploadPath)
                        print(deleteObjectError)
                    }
                   
                    //
                    print("Closing the Opened Bucket...")
                    let closeBucketError = lO_libUplinkSwift.closeBucket(lO_BucketRef: lO_OpenBucket)
                    if !closeBucketError.isEqual(to: "") {
                        print("FAILed to close desired bucket!")
                        print(closeBucketError)
                    } else {
                        print("Desired Bucket: CLOSED!")
                    }
                } else {
                    print("FAILed to open desired bucket!")
                    print(openBucketError)
                }
                
            } else {
                print("FAILed to get encryption access from given passphrase")
                print(encryptionKeyError)
            }
            
            print("Deleting bucket :",storjBucket)
            //
            var deleteBucketError = lO_libUplinkSwift.deleteBucket(lO_ProjectRef: lO_ProjectRef, bucketName: storjBucket)
            //
            if deleteBucketError.isEqual(to: "") {
                print("Bucket : ",storjBucket," Deleted successfully")
            } else {
                print("FAILed to delete bucket :",storjBucket)
                print(deleteBucketError)
            }
            //
            
            print("Closing the opened Storj Project...")
            //
            let closeProjectError = lO_libUplinkSwift.closeProject(lO_projectRef: lO_ProjectRef)
            //
            if closeProjectError != "" {
                print("FAILed to close the project!")
                print(closeProjectError)
            } else {
                print("Storj Project: CLOSED!")
            }
            
        } else {
            print("FAILed to open desired Storj project!")
            print(openProjectError)
        }
        
    } else {
        print("FAILed to parse the API key!")
        print(parseAPIKeyError)
    }
    //
    print("Closing the established Storj Uplink...")
    
    let closeUplinkError = lO_libUplinkSwift.closeUplink(lO_uplinkRef: lO_uplinkRef)
    if closeUplinkError != "" {
        print("FAILed to close uplink")
        print(closeUplinkError)
    }
    
} else {
    print("FAILed to set-up a new uplink!")
    print(uplinkError)
}

