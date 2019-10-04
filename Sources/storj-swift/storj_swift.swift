import Foundation
import Clibuplink

public struct libUplinkSwift {
    
    public var dynamicFileLocation : String?
    
    public init(_ userLiblocation :String){
        if !userLiblocation.isEmpty{
            self.dynamicFileLocation = userLiblocation
        } else {
            self.dynamicFileLocation = "/Users/webwerks/swift/src/helloStorjSwift/storj-swift/Sources/Clibuplink/include/libuplinkc.dylib"
        }
        
    }
    //
    typealias newUplink = @convention(c)(UplinkConfig,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(UplinkRef)
    //
    typealias close_uplink = @convention(c)(UplinkRef, UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)-> ()
    //
    typealias parse_api_key = @convention(c)(UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->APIKeyRef
    //
    typealias open_project = @convention(c)(UplinkRef,UnsafeMutablePointer<Int8>?,APIKeyRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->ProjectRef
     //
     typealias encryption_key_custom = @convention(c)(Int32, UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->Int32
     //
     typealias open_bucket = @convention(c)(ProjectRef ,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)-> BucketRef
    //
     typealias upload_custom = @convention(c)(Int32, UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->Int32
     
     typealias download_custom = @convention(c)(Int32, UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->Int32
     typealias create_bucket = @convention(c)(ProjectRef,UnsafeMutablePointer<Int8>?,UnsafeMutableRawPointer?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)-> BucketInfo
    //
    typealias list_buckets = @convention(c)(ProjectRef,UnsafeMutablePointer<BucketListOptions>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(BucketList)

    //
    typealias free_bucket_list = @convention(c)(UnsafeMutablePointer<BucketList>)->()
    //
    typealias close_project = @convention(c)(ProjectRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias project_salted_key_from_passphrase = @convention(c)(ProjectRef,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(UnsafeMutablePointer<UInt8>)
    //
    //
    typealias new_encryption_access_with_default_key = @convention(c)(UnsafeMutablePointer<UInt8>?)->(EncryptionAccessRef)
    //
    typealias serialize_encryption_access = @convention(c)(EncryptionAccessRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(UnsafeMutablePointer<Int8>?)
    //
    typealias delete_bucket = @convention(c)(ProjectRef,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias close_bucket = @convention(c)(BucketRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias upload = @convention(c)(BucketRef,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UploadOptions>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(UploaderRef)
    //
    typealias upload_write = @convention(c)(UploaderRef,UnsafeMutablePointer<UInt8>?,Int,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(Int)
    //
    typealias upload_commit  = @convention(c)(UploaderRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias download = @convention(c)(BucketRef ,UnsafeMutablePointer<Int8>? ,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(DownloaderRef)
    //
    typealias download_read = @convention(c)(DownloaderRef,UnsafeMutablePointer<UInt8>?,Int,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(Int)
    //
    typealias download_close = @convention(c)(DownloaderRef,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias list_objects = @convention(c)(BucketRef,UnsafeMutablePointer<ListOptions>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->(ObjectList)
    //
    typealias delete_object = @convention(c)(BucketRef,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?)->()
    //
    typealias free_list_objects = @convention(c)(UnsafeMutablePointer<ObjectList>?)->()

    //
    mutating public func Uplink() -> (UplinkRef,NSString) {
        //
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "new_uplink")
                //
                if(sym != nil){
                    //
                    let uplink = unsafeBitCast(sym, to: newUplink.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let uplinkconfig = UplinkConfig()
                    let uplinkhandle = uplink(uplinkconfig,&ptrToerror)
                    
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    return (uplinkhandle,error)
                    
                }else{
                    error = "Symbol not found in .dylib"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        
        return (UplinkRef(),error)
    }
    //
    mutating public func closeUplink(lO_uplinkRef:UplinkRef)->(NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "close_uplink")
                //close_uplink(UplinkRef p0, char** p1);
                if(sym != nil){
                    //
                    let close_uplink_func = unsafeBitCast(sym, to: close_uplink.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    close_uplink_func(lO_uplinkRef, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (error)
    }
    //
    mutating public func parseAPIKey(apiKey: NSString) -> (APIKeyRef,NSString) {
        //
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "parse_api_key")
                //
                if(sym != nil){
                    //
                    let parse_api_key_func = unsafeBitCast(sym, to: parse_api_key.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var ptrapiKey = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
                    //
                    let parseAPIHandle = parse_api_key_func(ptrapiKey,&ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (parseAPIHandle,error)
                    
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        
        return (APIKeyRef(),error)
    }
    //
    mutating public func openProject(uplinkRef :UplinkRef,satellite :NSString,parsedAPIRef :APIKeyRef)->(Project,NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "open_project")
                //
                if(sym != nil){
                    //
                    let openProject = unsafeBitCast(sym, to: open_project.self)
                    //
                    let ptrToSatelliteKey = UnsafeMutablePointer<CChar>(mutating: satellite.utf8String)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let openProjecthandle = openProject(uplinkRef , ptrToSatelliteKey, parsedAPIRef, &ptrToerror)
                    //
                    return (openProjecthandle,error)
                    
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (Project(),error)
    }
    //
    mutating public func closeProject(lO_projectRef: ProjectRef)->(NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "close_project")
                //
                if(sym != nil){
                    //
                    let close_project_func = unsafeBitCast(sym, to: close_project.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    close_project_func(lO_projectRef, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (error)
    }
    //
    mutating public func createBucket(lO_projectRef :ProjectRef,bucketName :NSString)->(BucketInfo,NSString){
        //
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "create_bucket")
                //
                if(sym != nil){
                    //
                    let createBucket = unsafeBitCast(sym, to: create_bucket.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    //
                    var lO_BucketConfig = BucketConfig()
                    
                    let ptrToBucketConfig = UnsafeMutablePointer<BucketConfig>(&lO_BucketConfig)
                    
                    let createBucketResult = createBucket(lO_projectRef,ptrToBucketName, ptrToBucketConfig, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (createBucketResult,error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (BucketInfo(),error)
    }
    //
    mutating public func listBuckets(lO_ProjectRef: ProjectRef, lO_BucketListOption : inout BucketListOptions)->(BucketList,NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "list_buckets")
                //
                if(sym != nil){
                    //
                    let list_buckets_func = unsafeBitCast(sym, to: list_buckets.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var bucketListOptionPtr = UnsafeMutablePointer<BucketListOptions>(&lO_BucketListOption)
                    //
                    let listBucket = list_buckets_func(lO_ProjectRef, bucketListOptionPtr, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (listBucket,error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (BucketList(),error)
        
    }
    //
    mutating public func freeBucketList(bucketListPtr: UnsafeMutablePointer<BucketList>)->(NSString){
        //
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "free_bucket_list")
                //
                if(sym != nil){
                    //
                    let free_bucket_list_func = unsafeBitCast(sym, to: free_bucket_list.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    free_bucket_list_func(bucketListPtr)
                    //
                    
                    //
                    return (error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (error)
        //
    }
    //
    mutating public func deleteBucket(lO_ProjectRef: ProjectRef, bucketName: NSString)->(NSString){
        //
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "delete_bucket")
                //
                if(sym != nil){
                    //
                    let delete_bucket_func = unsafeBitCast(sym, to: delete_bucket.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    //
                    delete_bucket_func(lO_ProjectRef,ptrToBucketName,&ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (error)
    }
    //
    mutating public func getEncryptionAccess(lO_ProjectRef :Project, encryptionPassphrase :NSString)-> (UnsafeMutablePointer<Int8>?, NSString){
            //
            var error : NSString = ""
            //
            let fileManger = FileManager.default
            //
            if fileManger.fileExists(atPath: self.dynamicFileLocation!){
                //
                let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
                if(dynammicFileHandle != nil){
                    //
                    let sym = dlsym(dynammicFileHandle, "project_salted_key_from_passphrase")
                    //
                    let sym1 = dlsym(dynammicFileHandle, "new_encryption_access_with_default_key")
                    //
                    let sym2 = dlsym(dynammicFileHandle, "serialize_encryption_access")
                    //
                    let sym3 = dlsym(dynammicFileHandle, "serialize_encryption_access_custom")
                    //
                    if((sym != nil) && (sym1 != nil) && (sym2 != nil)){
                        //
                        let project_salted_key_from_passphrase_func = unsafeBitCast(sym, to: project_salted_key_from_passphrase.self)
                        //
                        let new_encryption_access_with_default_key_func = unsafeBitCast(sym1, to: new_encryption_access_with_default_key.self)
                        //
                        let serialize_encryption_access_func = unsafeBitCast(sym2, to: serialize_encryption_access.self)
                        //
                        
                        //
                        var ptrToError = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                        //
                        let ptrToEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
                        //
                        var ptrSaltedKeyFromPassphrase = project_salted_key_from_passphrase_func(lO_ProjectRef,ptrToEncryptionPassphrase,&ptrToError)
                        //
                        if let errorCstring = ptrToError {
                            error = String(cString: errorCstring) as NSString
                        }
                        //
                        if !error.isEqual(to: "") {
                            return (nil,error)
                        }
                        //
                        var lO_EncryptionAccessRef = new_encryption_access_with_default_key_func(ptrSaltedKeyFromPassphrase)
                        //
                        if let errorCstring = ptrToError {
                            error = String(cString: errorCstring) as NSString
                        }
                        //
                        var ptrSerializedAccess = serialize_encryption_access_func(lO_EncryptionAccessRef, &ptrToError)
                        //
                        if let errorCstring = ptrToError {
                            error = String(cString: errorCstring) as NSString
                        }
                        //
                        return (ptrSerializedAccess ,error)
                    }else{
                        error = "Symbol not found in .dylib file"
                    }
                }else{
                    //
                    error = "FAILed to open .dylib file"
                    //
                }
                
            }else{
                error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
            }
            return (nil,error)
    
    }
    //
    mutating public func openBucket(lO_ProjectRef: ProjectRef, bucketName: NSString, ptrSerialAccess: UnsafeMutablePointer<Int8>?)->(BucketRef,NSString){
        var error : NSString = ""
        //
        if ptrSerialAccess == nil {
            
            error = "Serialized access pointer is null"
            return (BucketRef(),error)
        }
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "open_bucket")
                //
                if(sym != nil){
                    //
                    let open_bucket_func = unsafeBitCast(sym, to: open_bucket.self)
                    //
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let lO_OpenBucketRef = open_bucket_func(lO_ProjectRef , ptrToBucketName, ptrSerialAccess, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    
                    return (lO_OpenBucketRef,error)
                    
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (BucketRef(),error)
    }
    //
    mutating public func closeBucket(lO_BucketRef: BucketRef)->(NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation!  ,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "close_bucket")
                //
                if(sym != nil){
                    //
                    let close_bucket_func = unsafeBitCast(sym, to: close_bucket.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    close_bucket_func(lO_BucketRef, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                     error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (error)
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (error)
    }
    //
    mutating public func Upload(lO_bucketRef :Bucket, storjUploadPath :NSString,  localFullFileNameToUpload :NSString, lO_uploadPathPtr :UnsafeMutablePointer<UploadOptions>)->(UploaderRef , NSString){
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "upload")
                //
                if(sym != nil){
                    //
                    let upload_func = unsafeBitCast(sym, to: upload.self)
                    //
                    let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    let lO_UploaderRef = upload_func(lO_bucketRef, ptrStorjPath, lO_uploadPathPtr, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    
                    return (lO_UploaderRef,error)
                    
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (UploaderRef(),error)
    }
    //
    mutating public func UploadWrite(uploaderRef :Uploader, ptrdataInUint :UnsafeMutablePointer<UInt8>,sizeToWrite :Int)->(Int,NSString)  {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "upload_write")
                //
                if(sym != nil){
                    //
                    let upload_write_func = unsafeBitCast(sym, to: upload_write.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var sizeOnStorj = upload_write_func(uploaderRef, ptrdataInUint, sizeToWrite, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    
                    return (sizeToWrite,error)
                    
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (0,error)
    }
    //
    mutating public func UploadCommit(uploaderRef :Uploader)->NSString {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "upload_commit")
                //
                if(sym != nil){
                    //
                    let upload_commit_func = unsafeBitCast(sym, to: upload_commit.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    upload_commit_func(uploaderRef, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return error
    }
    //
    mutating public func Download(lO_bucketRef :Bucket,storjFullFilename :NSString)->(Downloader,NSString) {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "download")
                //
                if(sym != nil){
                    //
                    let download_func = unsafeBitCast(sym, to: download.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var ptrStorjFullFilename = UnsafeMutablePointer<CChar>(mutating: storjFullFilename.utf8String)
                    //
                    let downloader = download_func(lO_bucketRef, ptrStorjFullFilename, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (downloader,error)
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (DownloaderRef(),error)
    }
    //
    mutating public func downloadRead(lO_downloader :Downloader, ptrtoreceivedData: UnsafeMutablePointer<UInt8>,size_to_write :Int)->(Int, NSString) {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "download_read")
                //
                if(sym != nil){
                    //
                    let download_read_func = unsafeBitCast(sym, to: download_read.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var downloaddata = download_read_func(lO_downloader, ptrtoreceivedData, size_to_write, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                    return (downloaddata,error)
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (0,error)
    }
    //
    mutating public func downloadClose(lO_downloader :Downloader)->NSString {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "download_close")
                //
                if(sym != nil){
                    //
                    let download_close_func = unsafeBitCast(sym, to: download_close.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    download_close_func(lO_downloader, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    return error
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return error
    }
    //
    mutating public func listObjects(lO_bucketRef :Bucket,lO_ListOption : inout ListOptions) -> (ObjectList,NSString) {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "list_objects")
                //
                if(sym != nil){
                    //
                    let list_objects_func = unsafeBitCast(sym, to: list_objects.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var listOptionPtr = UnsafeMutablePointer<ListOptions>(&lO_ListOption)
                    //
                    let lO_listObject = list_objects_func(lO_bucketRef, listOptionPtr, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    return (lO_listObject,error)
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return (ObjectList(),error)
    }
    //
    mutating public func freeObjectList(objectListPointer :UnsafeMutablePointer<ObjectList>)-> NSString {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "free_list")
                //
                if(sym != nil){
                    //
                    let free_list_objects_func = unsafeBitCast(sym, to: free_list_objects.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    free_list_objects_func(objectListPointer)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return error
    }
    //
    mutating public func deleteObject(lO_bucketRef :Bucket ,storjObjectPath :NSString)-> NSString {
        var error : NSString = ""
        //
        let fileManger = FileManager.default
        //
        if fileManger.fileExists(atPath: self.dynamicFileLocation!){
            //
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if(dynammicFileHandle != nil){
                //
                let sym = dlsym(dynammicFileHandle, "delete_object")
                //
                if(sym != nil){
                    //
                    let delete_object_func = unsafeBitCast(sym, to: delete_object.self)
                    //
                    var ptrToerror = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
                    //
                    var ptrStorjObjectPath = UnsafeMutablePointer<CChar>(mutating: storjObjectPath.utf8String)
                    //
                    delete_object_func(lO_bucketRef, ptrStorjObjectPath, &ptrToerror)
                    //
                    if let errorCstring = ptrToerror {
                        error = String(cString: errorCstring) as NSString
                    }
                    //
                }else{
                    error = "Symbol not found in .dylib file"
                }
            }else{
                error = "FAILed to open .dylib file"
            }
            
        }else{
            error = "File does not exists on Path : "+self.dynamicFileLocation! as NSString
        }
        return error
    }
}
