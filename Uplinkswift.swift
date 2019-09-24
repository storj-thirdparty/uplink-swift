//
//  storj.swift
//  storj-swift binding
//


import Foundation


public struct libUplinkSwift {
    public init(){}
    /*
     * function to create new Storj uplink
     * pre-requisites: none
     * inputs: none
     * output: returns Uplink and error (NSString)
     */
    mutating public func newUplink()-> (Uplink, NSString) {
        
        var error : NSString = ""
        //
        let uplinkConfig = UplinkConfig()
        //
        // create pointer to error string
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        // call golang function to create a new uplink
        let lO_uplinkRef = new_uplink(uplinkConfig, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        return (lO_uplinkRef, error)
    }
    
    /*
     * function to close currently open uplink
     * pre-requisites: newUplink() function has been already called
     * inputs: Uplink
     * output: returns error (NSString)
     */
    mutating public func closeUplink(lO_uplinkRef :Uplink)-> NSString {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        close_uplink(lO_uplinkRef, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        return error
    }

    
    /*
     * function to parse API key, to be used by Storj
     * pre-requisites: none
     * inputs: API key (NSString)
     * output: returns APIKey nad error (NSString)
     */
    mutating public func parseAPIKey(apiKey :NSString)-> (APIKey, NSString) {
        var error : NSString = ""
        // Create pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // Create pointer to API key
        let apiKeyPtr = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
        //
        let lO_parsedAPIKeyRef = parse_api_key(apiKeyPtr, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        return (lO_parsedAPIKeyRef, error)
    }
    
    /*
     * openProject function to opens a Storj project.
     * pre-requisites: uplink() and parseAPIKey() functions have been already called
     * inputs: Uplink, Satellite Address (NSString), APIKey
     * output: returns Project, error (NSString)
     */
    mutating public func openProject(lO_uplinkRef :Uplink , satellite :NSString, lO_parsedAPIKeyRef :APIKey) -> (Project, NSString) {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // Creating Ptr to satellite address
        let satellitePtr = UnsafeMutablePointer<CChar>(mutating: satellite.utf8String)
        //
        let lO_projectRef = open_project(lO_uplinkRef, satellitePtr, lO_parsedAPIKeyRef, &errorPtr)
        // Converting cString to NSString
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        return (lO_projectRef, error)
    }
    
    /*
     * function to close currently open Storj project
     * pre-requisites: openProject() function has been already called
     * inputs: Project
     * output: returns error (NSString)
     */
    mutating public func closeProject(lO_projectRef :Project) -> NSString {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        close_project(lO_projectRef, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        return error
    }
    
    /*
     * function to create a new bucket in Storj project
     * pre-requisites: openProject() function has been already called
     * inputs: Project, Bucket Name (NSString)
     * output: returns BucketInfo and error (NSString)
     */
    mutating public func createBucket(lO_projectRef :Project, bucketName :NSString)-> (BucketInfo, NSString) {
        var error : NSString = ""
        //
        var bucketconfig = BucketConfig()
        //  Checking bucketName
        if bucketName.isEqual(to: "") {
            return (BucketInfo(), error)
        }
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // Creating pointer to bucketName
        let bucketnamePtr = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
        //
        let bucketconfigPtr = UnsafeMutablePointer<BucketConfig>(&bucketconfig)
        //
        let lO_bucketInfo = create_bucket(lO_projectRef, bucketnamePtr, bucketconfigPtr, &errorPtr)
        // Checking for error
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        return (lO_bucketInfo, error)
    }
    
    /*
     * function to get encryption access to upload and download data on Storj
     * pre-requisites: openProject() function has been already called
     * inputs: Project, Encryption Pass Phrase (NSString)
     * output: returns Serialized Encryption Access (UnsafeMutablePointer<Int8>?) and error (NSString); if it fails, nil Pointer is returned
     */
    mutating public func getEncryptionAccess(lO_projectRef :Project, encryptionPassphrase :NSString)-> (UnsafeMutablePointer<Int8>?, NSString) {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // Creating pointer to encryptionPhassphrase
        let encryptionPassphrasePtr = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
        //
        let ptrSaltedKeyFromPassphrase = project_salted_key_from_passphrase(lO_projectRef, encryptionPassphrasePtr, &errorPtr)
        // Converting cString to NSString
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        if error != "" {
            return (nil, error)
        }
        //
        let lO_encryptionRef = new_encryption_access_with_default_key(ptrSaltedKeyFromPassphrase)
        // Converting cString to NSString
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        if error != "" {
            return (nil, error)
        }
        //
        let ptrSerialized = serialize_encryption_access(lO_encryptionRef, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        if error != "" {
            return (nil, error)
        }
        //
        return (ptrSerialized, error)
    }
    
    /*
     * function to open an already existing bucket in Storj project
     * pre-requisites: getEncryptionAccess() function has been already called
     * inputs: Project, Bucket Name (NSString), Serialized Encryption Access (UnsafeMutablePointer<Int8>?)
     * output: returns Bucket and error (NSString)
     */
    mutating public func openBucket(lO_projectRef :Project, bucket :NSString, ptrSerialAccess :UnsafeMutablePointer<Int8>?)-> (Bucket, NSString) {
        var error : NSString = ""
        // Creating pointer to array
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // Creating pointer to bucketname
        let bucketnamePtr = UnsafeMutablePointer<CChar>(mutating: bucket.utf8String)
        //
        var  lO_bucketRef = Bucket()
        //
        if ptrSerialAccess != nil {
            lO_bucketRef = open_bucket(lO_projectRef, bucketnamePtr, ptrSerialAccess, &errorPtr)
        }
        // Checking for error
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        //
        return (lO_bucketRef, error)
    }
    /*
     * function to list all the buckets in a Storj project
     * pre-requeisites: openProject() function has been already called
     * inputs: Project, address of BucketListOptions
     * output: returns BucketList and error (NSString)
     */
     mutating public func listBuckets(lO_ProjectRef: Project, lO_BucketListOption: inout BucketListOptions)->(BucketList, NSString) {
         var error : NSString = ""
         // Creating pointer to error
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         var bucketListOptionPtr = UnsafeMutablePointer<BucketListOptions>(&lO_BucketListOption)
         //
         var lO_listBucket = list_buckets(lO_ProjectRef, bucketListOptionPtr, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         return (lO_listBucket, error)
     }
    
    /*
     * function to free Bucket list
     * pre-requeisites: listBucket() function has been already called
     * inputs: Pointer to BucketList (UnsafeMutablepointer<BucketList>)
     * output: returns error (NSString)
     */
     mutating public func freeBucketList(bucketListPointer :UnsafeMutablePointer<BucketList>)-> NSString {
         var error : NSString = ""
         // Creating pointer to error
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         free_bucket_list(bucketListPointer)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         return (error)
     }
    
    /*
     * function to close currently open Bucket
     * pre-requisites: openBucket() function has been already called, successfully
     * inputs: Bucket
     * output: returns error (NSString)
     */
    mutating public func closeBucket(lO_bucketRef :Bucket) -> NSString {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        close_bucket(lO_bucketRef, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        return error
    }

   /*
    * function to delete a empty bucket
    * pre-requeisites: openBucket() function has been already called
    * inputs: Project, Storj Bucket Name (NSString)
    * output: returns BucketList and error (NSString)
    */
    mutating public func deleteBucket(lO_ProjectRef :Project,bucketName :NSString)-> NSString {
        var error : NSString = ""
        // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        var bucketNamePtr = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
        //
        delete_bucket(lO_ProjectRef, bucketNamePtr, &errorPtr)
        //
        if let errorCstring = errorPtr {
            error = String(cString: errorCstring) as NSString
        }
        return (error)
        
    }
    /*
     * function to list object in desired bucket
     * pre-requeisites: openBucket() function has been already called
     * inputs: Bucket, address of ListOptions
     * output: returns ObjectList and error (NSString)
     */
     mutating public func listObjects(lO_bucketRef :Bucket,lO_ListOption : inout ListOptions) -> (ObjectList,NSString) {
        var error : NSString = ""
         // Creating pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
        let listOptionPtr = UnsafeMutablePointer<ListOptions>(&lO_ListOption)
         //
        let lO_listObject = list_objects(lO_bucketRef, listOptionPtr, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return (lO_listObject,error)
     }
     
    /*
     * function to delete an object in a bucket
     * pre-requeisites: openBucket() function has been already called
     * inputs: Bucket, Storj Path/File Name (NSString)
     * output: returns BucketList and error (NSString)
     */
     mutating public func deleteObject(lO_bucketRef :Bucket ,storjObjectPath :NSString)-> NSString {
         var error : NSString = ""
         // Creating pointer to error
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         var objectPathPtr = UnsafeMutablePointer<CChar>(mutating: storjObjectPath.utf8String)
         //
         delete_object(lO_bucketRef, objectPathPtr, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         return (error)
     }
     
    /*
     * function to free ObjectList
     * pre-requeisites: listObject() function has been already called
     * inputs: Pointer to ObjectList (UnsafeMutablepointer<ObjectList>)
     * output: returns error (NSString)
     */
     mutating public func freeObjectList(objectListPointer :UnsafeMutablePointer<ObjectList>)-> NSString {
         var error : NSString = ""
         // Creating pointer to error
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         free_list_objects(objectListPointer)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return error
     }
     
    /*
     * function to get uploader handle used to upload data to Storj (V3) bucket's path
     * pre-requeisites: openBucket function has been already called
     * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Source Full File Name (NSString)
     * output: returns Uploder and error (NSString)
     */
     mutating public func Upload(lO_bucketRef :Bucket, storjUploadPath :NSString,  localFullFileNameToUpload :NSString, lO_uploadPathPtr :UnsafeMutablePointer<UploadOptions>)->(Uploader , NSString) {
         //
         var error : NSString = ""
         // Creating pointer to error
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
         //
         var uploaderRef = upload(lO_bucketRef, ptrStorjPath, lO_uploadPathPtr, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return (uploaderRef,error)
     }
     
    /*
     * function to write data to Storj (V3) bucket's path
     * pre-requeisites: Upload function has been already called
     * inputs: Uploader, Pointer to bytes array (UnsafeMutablepointer<UInt8>) , sizeofbytesarray(Int)
     * output: returns Size of data uploaded (Int) and error (NSString)
     */
     mutating public func UploadWrite(uploaderRef :Uploader, ptrdataInUint :UnsafeMutablePointer<UInt8>,sizeToWrite :Int)->(Int,NSString) {
         //
         var error : NSString = ""
         //
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         var sizeOnStorj = upload_write(uploaderRef, ptrdataInUint, sizeToWrite, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return (sizeOnStorj,error)
     }
    
    /*
     * function to commit and finalize file for uploaded data to Storj (V3) bucket's path
     * pre-requeisites: Upload function has been already called
     * inputs: Uploader
     * output: returns error (NSString)
     */
     mutating public func UploadCommit(uploaderRef :Uploader)->NSString {
         var error : NSString = ""
         //
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         upload_commit(uploaderRef, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return error
     }
     
    /*
     * function to get downloader handle to download Storj (V3) object's data and store it on local computer
     * pre-requeisites: openBucket() function has been already called
     * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Full File Name (NSString)
     * output: returns Downloader and error (NSString)
     */
     mutating public func Download(lO_bucketRef :Bucket,storjFullFilename :NSString)->(Downloader,NSString) {
         var error : NSString = ""
         //
         // Creating pointer to string
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         let storjFullFilenamePointer = UnsafeMutablePointer<CChar>(mutating: storjFullFilename.utf8String)
         //
         let downloader = download(lO_bucketRef, storjFullFilenamePointer, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         return (downloader,error)
     }
     
    /*
     * function to read Storj (V3) object's data and return the data
     * pre-requeisites: Download function has been already called
     * inputs: Downloader, Pointer to bytes array (UnsafeMutablepointer<UInt8>) , sizeofbytesarray(Int)
     * output: returns Size of downloaded data (Int) and error (NSString)
     */
     mutating public func downloadRead(lO_downloader :Downloader, ptrtoreceivedData: UnsafeMutablePointer<UInt8>,size_to_write :Int)->(Int, NSString) {
         var error : NSString = ""
         //
         // Creating pointer to string
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         var downloaddata = download_read(lO_downloader, ptrtoreceivedData, size_to_write, &errorPtr)
         
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         //
         return (downloaddata,error)
     }
     
     /*
      * function to close downloader after completing the data read process
      * pre-requeisites: Download function has been already called
      * inputs: Downloader
      * output: returns error (NSString)
      */
     mutating public func downloadClose(lO_downloader :Downloader)->NSString {
         var error : NSString = ""
         // Creating pointer to string
         var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
         //
         download_close(lO_downloader, &errorPtr)
         //
         if let errorCstring = errorPtr {
             error = String(cString: errorCstring) as NSString
         }
         return error
     }
    
    /* function to upload data from localFullFileNameToUpload (at local system) to Storj (V3) bucket's path
     * pre-requeisites: openBucket() function has been already called
     * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Source Full File Name (NSString)
     * output: returns error (NSString)
     */
    mutating func uploadFile(lO_bucketRef :Bucket, storjUploadPath :NSString,  localFullFileNameToUpload :NSString) -> NSString {
        //
        var error : NSString = ""
        //
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        // Checking for filename
        if ((!storjUploadPath.isEqual(to: "")) && (!localFullFileNameToUpload.isEqual(to: ""))) {
            // If filename is not blank
            let fileManger = FileManager.default
            //
            // Check if file exits or not on localsystem
            if fileManger.fileExists(atPath: localFullFileNameToUpload as String) {
                // If file is readable or not
               if fileManger.isReadableFile(atPath: localFullFileNameToUpload as String) {
                    // Reading file size
                    do {
                        // Fetching file details for reading file size
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
                            var buff = Data(capacity: 256)
                            //
                            let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
                            //
                            var lO_uploadOption = UploadOptions()
                            //
                            let lO_uploadPathPtr = UnsafeMutablePointer<UploadOptions>(&lO_uploadOption)
                            //
                            var uploaderRef = upload(lO_bucketRef, ptrStorjPath, lO_uploadPathPtr, &errorPtr)
                            //
                            if let errorCstring = errorPtr {
                                error = String(cString: errorCstring) as NSString
                            }
                            //
                            if error != "" {
                                return error
                            }
                            //
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
                                var data = fileHandle?.readData(ofLength: sizeToWrite)
                                //
                                var uploaderPtr = UnsafeMutablePointer<Uploader>(&uploaderRef)
                                // Saving data in UInt8 array from Data type
                                //
                                var dataInUint = [UInt8](data.map{$0}!)
                                //
                                let ptrdataInUint = UnsafeMutablePointer<UInt8>(&dataInUint)
                                //
                                upload_write(uploaderRef, ptrdataInUint, sizeToWrite, &errorPtr)
                                //
                                if let errorCstring = errorPtr {
                                    error = String(cString: errorCstring) as NSString
                                }
                                //
                                if error != "" {
                                    return error
                                }
                                //
                                totalBytesRead += sizeToWrite
                                //
                                buff.removeAll()
                            }
                            //
                            if fileHandle != nil {
                                fileHandle?.closeFile()
                            }
                            //
                            upload_commit(uploaderRef, &errorPtr)
                                    
                            if let errorCstring = errorPtr {
                                error = String(cString: errorCstring) as NSString
                            }
                            if error != "" {
                                return error
                            }
                        }
                        
                    } catch {
                        return "Error while reading filesize."
                    }
                
                } else {
                    return "File : "+(localFullFileNameToUpload as String)+"\n . File is not readable" as NSString
                }
            } else {
                return "File : "+(localFullFileNameToUpload as String)+" \n . File does not exists. Please enter valid filename." as NSString
            }
        } else {
            error = ""
            if storjUploadPath.isEqual(to: "") {
                error = (error as String)+" Please enter valid storjPath. \n" as NSString
            }
            if localFullFileNameToUpload.isEqual(to: "") {
                error = (error as String)+"Please enter valid filename to upload." as NSString
            }
        }
        return error
    }
    
   /* function to download Storj (V3) object's data and store it in given file with localFullFilename (on local system)
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Full File Name (NSString)
    * output: returns error (NSString)
    */
    mutating func downloadFile(lO_bucketRef :Bucket, storjFullFilename :NSString, localFullFilename :NSString) -> NSString {
        var error : NSString = ""
        // Creating pointer to string
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        let fileManger = FileManager.default
        //
        let path = fileManger.currentDirectoryPath
        //
        var locationDownloadFullFilename : NSString = ""
        //
        let blank : NSString = ""
        //
        let list = storjFullFilename.components(separatedBy: "/")
        //
        if((storjFullFilename != blank) && (localFullFilename != blank)) {
            if(localFullFilename.contains("/")) {
                let localfilelist = localFullFilename.components(separatedBy: "/")
                    if(localfilelist[localfilelist.count-1].contains(".")) {
                        locationDownloadFullFilename = localFullFilename
                    } else {
                        locationDownloadFullFilename = (localFullFilename) as String + list[list.count-1] as NSString
                    }
                } else {
                    locationDownloadFullFilename = path + list[list.count-1] as NSString
                }
            // Creating pointer storjPath
            let storjFullFilenamePointer = UnsafeMutablePointer<CChar>(mutating: storjFullFilename.utf8String)
            // Creating pointer localDownload Path
            let localFullFilenamePointer = UnsafeMutablePointer<CChar>(mutating: locationDownloadFullFilename.utf8String)
            //
            let downloader = download(lO_bucketRef, storjFullFilenamePointer, &errorPtr)
            //
            if let errorCstring = errorPtr {
                error = String(cString: errorCstring) as NSString
            }
            //
            if error != "" {
                return error
            }
            //
            let fileManger = FileManager.default
            // Checking file already exits or not
            if fileManger.fileExists(atPath: locationDownloadFullFilename as String) {
            // If file exits then delete
            if fileManger.isDeletableFile(atPath: locationDownloadFullFilename as String) {
                do {
                     var result = try fileManger.removeItem(atPath: locationDownloadFullFilename as String)
                } catch {
                        return "Error while deleting already existing file."
                    }
                } else {
                    return "File is not deletableFile."
                }
            }
            //
            if !fileManger.createFile(atPath: locationDownloadFullFilename as String, contents: nil, attributes: nil) {
                return "Error while creating file on local system."
            }
            if fileManger.isWritableFile(atPath: locationDownloadFullFilename as String) {
                var writehandel = FileHandle(forWritingAtPath: locationDownloadFullFilename as String)
                //
                if writehandel != nil {
                    var size_to_write = 256
                    var download_total = 0
                    //
                    var lO_Objectref = open_object(lO_bucketRef, storjFullFilenamePointer, &errorPtr)
                    //
                    if let errorCstring = errorPtr {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    if error != "" {
                        return error
                    }
                    //
                    var objectmeta = get_object_meta(lO_Objectref, &errorPtr)
                    //
                    if let errorCstring = errorPtr {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    if error != blank {
                        return error
                    }
                    //
                    close_object(lO_Objectref, &errorPtr)
                    //
                    if let errorCstring = errorPtr {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    var buff = Data(capacity: 256)
                    //
                    var sizeOfFile = Int(objectmeta.size)
                    //
                    while true {
                        sizeOfFile = 256
                        // Creating array for receving data from golang
                        var receivedDataArray : [UInt8] = Array(repeating: 0, count: size_to_write)
                        // Creating pointer
                        var ptrtoreceivedData = UnsafeMutablePointer<UInt8>(&receivedDataArray)
                        //
                        var downloaddata = download_read(downloader, ptrtoreceivedData, size_to_write, &errorPtr)
                        //
                        if let errorCstring = errorPtr {
                            error = String(cString: errorCstring) as NSString
                        }
                        //
                        receivedDataArray.removeSubrange(downloaddata..<256)
                        //
                        if downloaddata == 0 {
                            break
                        }
                        //
                        if error != "" {
                            return error
                        }
                        //
                        download_total += size_to_write
                        //
                        buff.append(contentsOf: receivedDataArray)
                        //
                        var resultwrite = writehandel?.write((buff))
                        //
                        buff.removeAll()
                    }
                    //
                    download_close(downloader, &errorPtr)
                    if let errorCstring = errorPtr {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    if error != "" {
                        return error
                    }
                    //
                    writehandel?.closeFile()
                    
                } else {
                    return  "File : "+(locationDownloadFullFilename as String)+" .File handle invalid." as NSString
                }
                //
            } else {
                
                return "File : "+(locationDownloadFullFilename as String)+" .File is not writeable." as NSString
            }
            
          if let errorCstring = errorPtr {
              error = String(cString: errorCstring) as NSString
          }
          return error
        }
        else {
            error = ""
            if (storjFullFilename == blank) {
                error = error as String+"Plese enter storjFullFilename for downloading object.\n" as NSString
                
            }
            if (localFullFilename == blank) {
                error = error as String+"Please enter localFullFilename for downloading object" as NSString
            }
            return error
        }
    }


    
}
