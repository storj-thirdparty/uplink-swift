import Foundation
import Clibuplink

//for throwing error
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
//Storj Swift
public struct Storj {
    public var dynamicFileLocation: String = ""
    public init(_ userLiblocation: String) {
        if !userLiblocation.isEmpty {
            self.dynamicFileLocation = userLiblocation
        } else {
            let storjswiftPath = URL(fileURLWithPath: #file)
            var storjSwiftPathString = storjswiftPath.path
            if (storjSwiftPathString.contains("storj-swift/")) {
                storjSwiftPathString = storjSwiftPathString.components(separatedBy: "storj-swift/")[0]
                storjSwiftPathString = storjSwiftPathString+"storj-swift/Sources/Clibuplink/include/libuplinkc.dylib"
                let fileManager = FileManager.default
                if (fileManager.fileExists(atPath: storjSwiftPathString)) {
                    self.dynamicFileLocation = storjSwiftPathString
                    }
                }
        }
    }
    //Errors
    var dylibNotFound: String = "Failed to find .dylib file at : "
    var failToOpenDylib: String = "Failed to open .dylib file"
    var failToFoundFunction: String = "Symbol not found in .dylib"
    //Creating typesalias of all the functions
    typealias parse_access = @convention(c)(UnsafeMutablePointer<Int8>?) -> (AccessResult)
    //
    typealias request_access_with_passphrase = @convention(c)(UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?) ->  (AccessResult)
    //
    typealias access_serialize = @convention(c)(UnsafeMutablePointer<Access>?) -> StringResult
    //
    typealias access_share = @convention(c)(UnsafeMutablePointer<Access>,Permission,UnsafeMutablePointer<SharePrefix>,GoInt)->AccessResult
    //
    typealias free_string_result = @convention(c)(StringResult) -> ()
    //
    typealias free_access_result = @convention(c)(AccessResult) -> ()
    //
    typealias stat_bucket = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias create_bucket = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?) ->  (BucketResult)
    //
    typealias ensure_bucket = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias delete_bucket = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias list_buckets = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<ListBucketsOptions>) ->  (UnsafeMutablePointer<BucketIterator>)
    //
    typealias bucket_iterator_next = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (Bool)
    //
    typealias bucket_iterator_err = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (UnsafeMutablePointer<Error>)
    //
    typealias bucket_iterator_item = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (UnsafeMutablePointer<Bucket>)
    //
    typealias free_bucket_iterator = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> ()
    //
    typealias config_request_access_with_passphrase = @convention(c)(Config,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?) -> (AccessResult)
    //
    typealias config_open_project = @convention(c)(Config,UnsafeMutablePointer<Access>?) -> (ProjectResult)
    //
    typealias download_object = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<DownloadOptions>) -> (DownloadResult)
    //
    typealias download_read = @convention(c)(UnsafeMutablePointer<Download>,UnsafeMutableRawPointer?,Int) -> (ReadResult)
    //
    typealias download_info = @convention(c)(UnsafeMutablePointer<Download>) -> (ObjectResult)
    //
    typealias upload_info = @convention(c)(UnsafeMutablePointer<Upload>) -> (ObjectResult)
    //
    typealias free_read_result = @convention(c)(ReadResult) -> ()
    //
    typealias close_download  = @convention(c)(UnsafeMutablePointer<Download>) -> (UnsafeMutablePointer<Error>)
    //
    typealias free_download_result = @convention(c)(DownloadResult) -> ()
    //
    typealias free_bucket_result = @convention(c)(BucketResult) -> ()
    //
    typealias free_error = @convention(c)(UnsafeMutablePointer<Error>) -> ()
    //
    typealias stat_object = @convention(c)(UnsafeMutablePointer<Project>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?) -> (ObjectResult)
    //
    typealias delete_object = @convention(c)(UnsafeMutablePointer<Project>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?) -> (ObjectResult)
    //
    typealias free_object_result = @convention(c)(ObjectResult) -> ()
    //
    typealias free_object = @convention(c)(UnsafeMutablePointer<Object>) -> ()
    //
    typealias list_objects = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<ListObjectsOptions>) -> (UnsafeMutablePointer<ObjectIterator>)
    //
    typealias object_iterator_next = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (Bool)
    //
    typealias object_iterator_err = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (UnsafeMutablePointer<Error>)
    //
    typealias object_iterator_item = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (UnsafeMutablePointer<Object>)
    //
    typealias free_object_iterator = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> ()
    //
    typealias open_project = @convention(c)(UnsafeMutablePointer<Access>) -> (ProjectResult)
    //
    typealias close_project = @convention(c)(UnsafeMutablePointer<Project>) -> (UnsafeMutablePointer<Error>)
    //
    typealias free_project_result = @convention(c)(ProjectResult) -> ()
    //
    typealias upload_object = @convention(c)(UnsafeMutablePointer<Project>,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<Int8>?,UnsafeMutablePointer<UploadOptions>) -> (UploadResult)
    //
    typealias upload_write = @convention(c)(UnsafeMutablePointer<Upload>,UnsafeMutableRawPointer?,Int) -> (WriteResult)
    //
    typealias upload_commit = @convention(c)(UnsafeMutablePointer<Upload>) -> (UnsafeMutablePointer<Error>)
    //
    typealias upload_abort = @convention(c)(UnsafeMutablePointer<Upload>) -> (UnsafeMutablePointer<Error>)
    //
    typealias upload_set_custom_metadata = @convention(c)(UnsafeMutablePointer<Upload>,CustomMetadata) -> (UnsafeMutablePointer<Error>)
    //
    typealias free_write_result = @convention(c)(WriteResult) -> ()
    //
    typealias free_upload_result = @convention(c)(UploadResult) -> ()
    //
    typealias free_bucket = @convention(c)(UnsafeMutablePointer<Bucket>) -> ()
    //
   //* function requests satellite for a new access grant using a passhprase
   //* pre-requisites: None
   //* inputs: Satellite Address, API Key and Encryptionphassphrase 
   //* output: AccessResult
    mutating public func request_Access_With_Passphrase(satelliteAddress:NSString,apiKey:NSString,encryptionPassphrase:NSString)throws -> (AccessResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "request_access_with_passphrase")
                if sym != nil {
                    let requestAccessWithPassphraseFunc = unsafeBitCast(sym, to: request_access_with_passphrase.self)
                    let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: satelliteAddress.utf8String)
                    let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
                    let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
                    let accessResult = requestAccessWithPassphraseFunc(ptrSatelliteAddress,ptrAPIKey,ptrEncryptionPassphrase)
                    return accessResult
                } else {
                    throw self.failToFoundFunction
                }
            } else {
                throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function requests satellite for a new access grant using a passhprase and config.
   //* pre-requisites: None
   //* inputs: None
   //* output: AccessResult
    mutating public func config_Request_Access_With_Passphrase(config:Config,satelliteAddress:NSString,apiKey:NSString,encryptionPassphrase:NSString)throws -> (AccessResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "config_request_access_with_passphrase")
                if sym != nil {
                    let configRequestAccessWithPassphraseFunc = unsafeBitCast(sym, to: config_request_access_with_passphrase.self)
                    let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: satelliteAddress.utf8String)
                    let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
                    let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
                    let accessResult = configRequestAccessWithPassphraseFunc(config,ptrSatelliteAddress,ptrAPIKey,ptrEncryptionPassphrase)
                    return accessResult
                } else {
                    throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to parses serialized access grant string
   //* pre-requisites: None
   //* inputs: StringKey
   //* output: AccessResult
    mutating public func parse_Access(stringKey:NSString)throws -> (AccessResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "parse_access")
                if sym != nil {
                    let parseAccessFunc = unsafeBitCast(sym, to: parse_access.self)
                    let ptrStringKey = UnsafeMutablePointer<CChar>(mutating: stringKey.utf8String)
                    let accessResult = parseAccessFunc(ptrStringKey)
                    return accessResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to serializes access grant into a string.
   //* pre-requisites: None
   //* inputs: Access
   //* output: StringResult
    mutating public func access_Serialize(access:inout Access)throws -> (StringResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "access_serialize")
                if sym != nil {
                    let accessSerializeFunc = unsafeBitCast(sym, to: access_serialize.self)
                    let stringResult = accessSerializeFunc(&access)
                    return stringResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to free memory associated with the StringResult
   //* pre-requisites: None
   //* inputs: StringResult
   //* output: None
    mutating public func free_String_Result(stringResult:inout StringResult)throws -> () {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_string_result")
                if sym != nil {
                    let freeStringResultFunc = unsafeBitCast(sym, to: free_string_result.self)
                    freeStringResultFunc(stringResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function returns information about a bucket.
   //* pre-requisites: None
   //* inputs: Config,Satellite Address, API Key and Encryptionphassphrase 
   //* output: BucketResult
    mutating public func stat_Bucket(project:inout UnsafeMutablePointer<Project>,bucketName:NSString)throws ->(BucketResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "stat_bucket")
                if sym != nil {
                    let statBucketFunc = unsafeBitCast(sym, to: stat_bucket.self)
                    let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    let bucketResult = statBucketFunc(project,ptrBucketName)
                    return bucketResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to create bucket on storj V3
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> and Bucket Name
   //* output: BucketResult
    mutating public func create_Bucket(project:inout UnsafeMutablePointer<Project>,bucketName:NSString)throws -> (BucketResult) {
         let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
             let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
             if dynammicFileHandle != nil {
                 let sym = dlsym(dynammicFileHandle, "create_bucket")
                 if sym != nil {
                     let createBucketFunc = unsafeBitCast(sym, to: create_bucket.self)
                     let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                     let bucketResult = createBucketFunc(project,ptrBucketName)
                     return (bucketResult)
                 } else {
                    throw self.failToFoundFunction
                 }
             } else {
                throw self.failToOpenDylib
             }
         } else {
            throw self.dylibNotFound+self.dynamicFileLocation
         }
     }
    //
   //* function to creates a new bucket and ignores the error when it already exists
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> and Bucket Name
   //* output: BucketResult
    mutating public func ensure_Bucket(project:inout UnsafeMutablePointer<Project>,bucketName:NSString)throws -> (BucketResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "ensure_bucket")
                if sym != nil {
                    let ensureBucketFunc = unsafeBitCast(sym, to: stat_bucket.self)
                    let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    let bucketResult = ensureBucketFunc(project,ptrBucketName)
                    return (bucketResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to delete empty bucket on storj V3
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> and Bucket Name
   //* output: BucketResult
    mutating public func delete_Bucket(project:inout UnsafeMutablePointer<Project>,bucketName:NSString)throws -> (BucketResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "delete_bucket")
                if sym != nil {
                    let deleteBucketFunc = unsafeBitCast(sym, to: delete_bucket.self)
                    let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    let bucketResult = deleteBucketFunc(project,ptrBucketName)
                    return bucketResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to lists buckets
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> and List Bucket Options
   //* output: UnsafeMutablePointer<BucketIterator>? or nil
    mutating public func list_Buckets(project:inout UnsafeMutablePointer<Project>,listBucketsOptionsObj:inout ListBucketsOptions)throws -> (UnsafeMutablePointer<BucketIterator>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "list_buckets")
                if sym != nil {
                    let listBucketsFunc = unsafeBitCast(sym, to: list_buckets.self)
                    let bucketIterator = listBucketsFunc(project,&listBucketsOptionsObj)
                    return bucketIterator
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function prepares next Bucket for reading.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<BucketIterator>
   //* output: Bool
    mutating public func bucket_Iterator_Next(bucketIterator:inout UnsafeMutablePointer<BucketIterator>)throws ->(Bool) {
        var bucketIteratorResult : Bool = false
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "bucket_iterator_next")
                if sym != nil {
                    let bucketIteratorNextFunc = unsafeBitCast(sym, to: bucket_iterator_next.self)
                    bucketIteratorResult = bucketIteratorNextFunc(bucketIterator)
                    return (bucketIteratorResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to returns the current bucket in the iterator.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<BucketIterator>
   //* output: UnsafeMutablePointer<Bucket>? or nil
    mutating public func bucket_Iterator_Item(bucketIterator:inout UnsafeMutablePointer<BucketIterator> )throws -> (UnsafeMutablePointer<Bucket>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "bucket_iterator_item")
                if sym != nil {
                    let bucketIteratorItemFunc = unsafeBitCast(sym, to: bucket_iterator_item.self)
                    let bucket = bucketIteratorItemFunc(bucketIterator)
                    return bucket
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function bucket_iterator_err returns error, if one happened during iteration.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<BucketIterator>
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func bucket_Iterator_Err(bucketIterator:inout UnsafeMutablePointer<BucketIterator> )throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "bucket_iterator_err")
                if sym != nil {
                    let bucketIteratorErrorFunc = unsafeBitCast(sym, to: bucket_iterator_err.self)
                    let error = bucketIteratorErrorFunc(bucketIterator)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to open project using access grant.
   //* pre-requisites:  request_Access_With_Passphrase or parse_Access function has been already called
   //* inputs: UnsafeMutablePointer<Access>
   //* output: ProjectResult
    mutating public func open_Project(access:inout UnsafeMutablePointer<Access>)throws -> (ProjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "open_project")
                if sym != nil {
                    let openProjectFunc = unsafeBitCast(sym, to: open_project.self)
                        let projectResult = openProjectFunc(access)
                        return projectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to open project using access grant and config
   //* pre-requisites: request_Access_With_Passphrase or parse_Access function has been already called
   //* inputs: UnsafeMutablePointer<Access>
   //* output: ProjectResult
    mutating public func config_Open_Project(config:Config,access:inout UnsafeMutablePointer<Access>)throws -> (ProjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "config_open_project")
                if sym != nil {
                    let configOpenProjectFunc = unsafeBitCast(sym, to: config_open_project.self)
                        let projectResult = configOpenProjectFunc(config,access)
                        return projectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function close the project.
   //* pre-requisites: open_Project function has been already called
   //* inputs: None
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func close_Project(project:inout UnsafeMutablePointer<Project>)throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "close_project")
                if sym != nil {
                    let closeProjectFunc = unsafeBitCast(sym, to: close_project.self)
                    let error = closeProjectFunc(project)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to start an upload to the specified key.
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project>, Object name and UnsafeMutablePointer<UploadOptions>
   //* output: UploadResult
    mutating public func upload_Object(project:inout UnsafeMutablePointer<Project>, storjBucketName :NSString,  storjUploadPath :NSString, uploadOptions :UnsafeMutablePointer<UploadOptions>)throws -> (UploadResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_object")
                if sym != nil {
                    let uploadObjectFunc = unsafeBitCast(sym, to: upload_object.self)
                    let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
                    let uploadResult = uploadObjectFunc(project, ptrToBucketName, ptrStorjPath, uploadOptions)
                    return (uploadResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to upload len(p) bytes from p to the object's data stream.
   //* pre-requisites: upload_Object function has been already called
   //* inputs: UnsafeMutablePointer<Upload> ,Pointer to buffer array , Len of buffer
   //* output: WriteResult
    mutating public func upload_Write(upload:inout UnsafeMutablePointer<Upload>, data :UnsafeMutablePointer<UInt8>,sizeToWrite :Int)throws -> (WriteResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_write")
                if sym != nil {
                    let uploadWriteFunc = unsafeBitCast(sym, to: upload_write.self)
                    let writeResult = uploadWriteFunc(upload, data, sizeToWrite)
                    return (writeResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to commits the uploaded data.
   //* pre-requisites: upload_Object function has been already called
   //* inputs: UnsafeMutablePointer<Upload>
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func upload_Commit(upload:inout UnsafeMutablePointer<Upload>)throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_commit")
                if sym != nil {
                    let uploadCommitFunc = unsafeBitCast(sym, to: upload_commit.self)
                    let error = uploadCommitFunc(upload)
                    return (error)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to abort current upload
   //* pre-requisites: upload_Object function has been already called
   //* inputs: UnsafeMutablePointer<Upload>
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func upload_Abort(upload:inout UnsafeMutablePointer<Upload>)throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_abort")
                if sym != nil {
                    let uploadAbortFunc = unsafeBitCast(sym, to: upload_abort.self)
                    let error = uploadAbortFunc(upload)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function to set custom metadata on storj V3 object
   //* pre-requisites: upload_Object function has been already called
   //* inputs: UnsafeMutablePointer<Upload> ,CustomMetadata
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func upload_Set_Custom_Metadata(upload:inout UnsafeMutablePointer<Upload>,customMetaDataObj:CustomMetadata)throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_set_custom_metadata")
                if sym != nil {
                    let uploadSetCustomMetadataFunc = unsafeBitCast(sym, to: upload_set_custom_metadata.self)
                    let error = uploadSetCustomMetadataFunc(upload,customMetaDataObj)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function for dowloading object
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> ,Object Name on storj V3 and UnsafeMutablePointer<DownloadOptions>
   //* output: DownloadResult
    mutating public func download_Object(project:inout UnsafeMutablePointer<Project>, storjBucketName :NSString,storjObjectName :NSString,downloadOptions :UnsafeMutablePointer<DownloadOptions>)throws -> (DownloadResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "download_object")
                if sym != nil {
                    let downloadObjectFunc = unsafeBitCast(sym, to: download_object.self)
                    let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
                    let downloadResult = downloadObjectFunc(project, ptrToBucketName, ptrStorjPath, downloadOptions)
                    return (downloadResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function reads byte stream from storj V3
   //* pre-requisites: download_Object function has been already called
   //* inputs: UnsafeMutablePointer<Download> ,Pointer to array buffer, Size of Buffer
   //* output: ReadResult
    mutating public func download_Read(download:inout UnsafeMutablePointer<Download>, data :UnsafeMutablePointer<UInt8>,sizeToWrite :Int)throws -> (ReadResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "download_read")
                if sym != nil {
                    let downloadReadFunc = unsafeBitCast(sym, to: download_read.self)
                    let readResult = downloadReadFunc(download, data, sizeToWrite)
                    return readResult
                } else {
                   throw "Symbol not found in .dylib file"
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function closes download
   //* pre-requisites: download_Object function has been already called
   //* inputs: UnsafeMutablePointer<Download>
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func close_Download(download:inout UnsafeMutablePointer<Download>)throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "close_download")
                if sym != nil {
                    let closeDownloadFunc = unsafeBitCast(sym, to: close_download.self)
                    let error =  closeDownloadFunc(download)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function returns metadata of downloading object
   //* pre-requisites: download_Object function has been already called
   //* inputs: UnsafeMutablePointer<Download>
   //* output: ObjectResult
    mutating public func download_Info(download:inout UnsafeMutablePointer<Download>)throws -> (ObjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "download_info")
                if sym != nil {
                    let downloadInfoFunc = unsafeBitCast(sym, to: download_info.self)
                    let objectResult =  downloadInfoFunc(download)
                    return objectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function return metadata of uploading object
   //* pre-requisites: upload_Object function has been already called
   //* inputs: UnsafeMutablePointer<Upload>
   //* output: ObjectResult
    mutating public func upload_Info(upload:inout UnsafeMutablePointer<Upload>)throws -> (ObjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "upload_info")
                if sym != nil {
                    let uploadInfoFunc = unsafeBitCast(sym, to: upload_info.self)
                    let objectResult =  uploadInfoFunc(upload)
                    return objectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function lists objects
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> ,Bucket Name and ListObjectsOptions
   //* output: UnsafeMutablePointer<ObjectIterator>? or nil
    mutating public func list_Objects(project:inout UnsafeMutablePointer<Project>, storjBucketName :NSString,listObjectsOptions:inout ListObjectsOptions)throws -> (UnsafeMutablePointer<ObjectIterator>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "list_objects")
                if sym != nil {
                    let listObjectsFunc = unsafeBitCast(sym, to: list_objects.self)
                    let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
                    let objectIterator = listObjectsFunc(project,ptrToBucketName,&listObjectsOptions)
                    return objectIterator
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function prepares next Object for reading.
   //* pre-requisites: list_Objects function has been already called
   //* inputs: None
   //* output: Bool
    mutating public func object_Iterator_Next(objectIterator:inout UnsafeMutablePointer<ObjectIterator>)throws -> (Bool) {
        var objectIteratorResult : Bool = false
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "object_iterator_next")
                if sym != nil {
                    let objectIteratorNextFunc = unsafeBitCast(sym, to: object_iterator_next.self)
                    objectIteratorResult = objectIteratorNextFunc(objectIterator)
                    return (objectIteratorResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function returns the current object in the iterator.
   //* pre-requisites: list_Objects function has been already called
   //* inputs: UnsafeMutablePointer<ObjectIterator>
   //* output: UnsafeMutablePointer<Object>? or nil
    mutating public func object_Iterator_Item(objectIterator:inout UnsafeMutablePointer<ObjectIterator> )throws -> (UnsafeMutablePointer<Object>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "object_iterator_item")
                if sym != nil {
                    let objectIteratorItemFunc = unsafeBitCast(sym, to: object_iterator_item.self)
                    let object = objectIteratorItemFunc(objectIterator)
                    return object
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function returns error, if one happened during iteration.
   //* pre-requisites: list_Objects function has been already called
   //* inputs: UnsafeMutablePointer<ObjectIterator>
   //* output: UnsafeMutablePointer<Error>? or nil
    mutating public func object_Iterator_Err(objectIterator:inout UnsafeMutablePointer<ObjectIterator> )throws -> (UnsafeMutablePointer<Error>?) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "object_iterator_err")
                if sym != nil {
                    let objectIteratorErrorFunc = unsafeBitCast(sym, to: object_iterator_err.self)
                    let error = objectIteratorErrorFunc(objectIterator)
                    return error
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function delete object from storj V3
   //* pre-requisites: open_Project function has been already called
   //* inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
   //* output: ObjectResult
    mutating public func delete_Object(project:inout UnsafeMutablePointer<Project>,bucketName:NSString,storjObjectName:NSString)throws ->(ObjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "delete_object")
                if sym != nil {
                    let deleteObjectFunc = unsafeBitCast(sym, to: delete_object.self)
                    let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
                    let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    let objectResult = deleteObjectFunc(project,ptrBucketName,ptrStorjObjectName)
                    return objectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function information about an object at the specific key.
   //* pre-requisites: open_project function has been already called
   //* inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
   //* output: ObjectResult
    mutating public func stat_Object(project:inout UnsafeMutablePointer<Project>,bucketName:NSString,storjObjectName:NSString)throws ->(ObjectResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "stat_object")
                if sym != nil {
                    let statObjectFunc = unsafeBitCast(sym, to: stat_object.self)
                    let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
                    let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
                    let objectResult = statObjectFunc(project,ptrBucketName,ptrStorjObjectName)
                    return objectResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function creates new access grant with specific permission. Permission will be applied to prefixes when defined.
   //* pre-requisites: None
   //* inputs: None
   //* output: AccessResult
    mutating public func access_Share(access:inout UnsafeMutablePointer<Access>,permission:inout Permission,prefix:inout UnsafeMutablePointer<SharePrefix>,prefixCount:Int)throws ->(AccessResult) {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "access_share")
                if sym != nil {
                    let accessShareFunc = unsafeBitCast(sym, to: access_share.self)
                    let accessResult = accessShareFunc(access,permission,prefix,GoInt(prefixCount))
                    return accessResult
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the BucketIterator.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<Access>,Permission, UnsafeMutablePointer<SharePrefix>,Size of Share Prefix
   //* output: None
    mutating public func free_Bucket_Iterator(bucketIterator:inout UnsafeMutablePointer<BucketIterator>)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_bucket_iterator")
                if sym != nil {
                    let freeBucketIteratorFunc = unsafeBitCast(sym, to: free_bucket_iterator.self)
                    freeBucketIteratorFunc(bucketIterator)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the Bucket.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<Bucket>
   //* output: Uplink and error (string)
    mutating public func free_Bucket(bucket:inout UnsafeMutablePointer<Bucket>)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_bucket")
                if sym != nil {
                    let freeBucketFunc = unsafeBitCast(sym, to: free_bucket.self)
                    freeBucketFunc(bucket)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the ObjectResult.
   //* pre-requisites: None
   //* inputs: ObjectResult
   //* output: None
    mutating public func free_Object_Iterator(objectIterator:inout UnsafeMutablePointer<ObjectIterator>)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_object_iterator")
                if sym != nil {
                    let freeObjectIteratorFunc = unsafeBitCast(sym, to: free_object_iterator.self)
                    freeObjectIteratorFunc(objectIterator)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the ReadResult.
   //* pre-requisites: None
   //* inputs: ReadResult
   //* output: None
    mutating public func free_Read_Result(readResult:inout ReadResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_read_result")
                if sym != nil {
                    let freeReadResultFunc = unsafeBitCast(sym, to: free_read_result.self)
                    freeReadResultFunc(readResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the DownloadResult.
   //* pre-requisites: None
   //* inputs: DownloadResult
   //* output: None
    mutating public func free_Download_Result(downloadResult:inout DownloadResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_download_result")
                if sym != nil {
                    let freeDownloadResultFunc = unsafeBitCast(sym, to: free_download_result.self)
                    freeDownloadResultFunc(downloadResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the BucketResult.
   //* pre-requisites: None
   //* inputs: BucketResult
   //* output: None
    mutating public func free_Bucket_Result(bucketResult:inout BucketResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_bucket_result")
                if sym != nil {
                    let freeBucketResultFunc = unsafeBitCast(sym, to: free_bucket_result.self)
                    freeBucketResultFunc(bucketResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the Error.
   //* pre-requisites: None
   //* inputs: inout UnsafeMutablePointer<Error>
   //* output: None
    mutating public func free_Error(error:inout UnsafeMutablePointer<Error>)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_error")
                if sym != nil {
                    let freeErrorFunc = unsafeBitCast(sym, to: free_error.self)
                    freeErrorFunc(error)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the ObjectResult.
   //* pre-requisites: None
   //* inputs: ObjectResult
   //* output: None
    mutating public func free_Object_Result(objectResult:inout ObjectResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_object_result")
                if sym != nil {
                    let freeObjectResultFunc = unsafeBitCast(sym, to: free_object_result.self)
                    freeObjectResultFunc(objectResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the Object.
   //* pre-requisites: None
   //* inputs: UnsafeMutablePointer<Object>
   //* output: None
    mutating public func free_Object(object:inout UnsafeMutablePointer<Object>)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_object")
                if sym != nil {
                    let freeObjectFunc = unsafeBitCast(sym, to: free_object.self)
                    freeObjectFunc(object)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the ProjectResult.
   //* pre-requisites: None
   //* inputs: ProjectResult
   //* output: None
    mutating public func free_Project_Result(projectResult:inout ProjectResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_project_result")
                if sym != nil {
                    let freeProjectResultFunc = unsafeBitCast(sym, to: free_project_result.self)
                    freeProjectResultFunc(projectResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the WriteResult.
   //* pre-requisites: None
   //* inputs: WriteResult
   //* output: None
    mutating public func free_Write_Result(writeResult:inout WriteResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_write_result")
                if sym != nil {
                    let freeWriteResultFunc = unsafeBitCast(sym, to: free_write_result.self)
                    freeWriteResultFunc(writeResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the UploadResult.
   //* pre-requisites: None
   //* inputs: UploadResult
   //* output: None
    mutating public func free_Upload_Result(uploadResult:inout UploadResult)throws ->() {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_upload_result")
                if sym != nil {
                    let freeUploadResultFunc = unsafeBitCast(sym, to: free_upload_result.self)
                    freeUploadResultFunc(uploadResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
    //
   //* function frees memory associated with the AccessResult.
   //* pre-requisites: None
   //* inputs: AccessResult
   //* output: None
    mutating public func free_Access_Result(accessResult:inout AccessResult)throws -> () {
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            let dynammicFileHandle = dlopen(self.dynamicFileLocation,RTLD_LOCAL|RTLD_NOW)
            if dynammicFileHandle != nil {
                let sym = dlsym(dynammicFileHandle, "free_access_result")
                if sym != nil {
                    let freeAccessResultFunc = unsafeBitCast(sym, to: free_access_result.self)
                    freeAccessResultFunc(accessResult)
                } else {
                   throw self.failToFoundFunction
                }
            } else {
               throw self.failToOpenDylib
            }
        } else {
           throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
}

