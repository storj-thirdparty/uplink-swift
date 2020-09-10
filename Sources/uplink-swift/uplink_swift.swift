import libuplink
import Foundation

//swiftlint:disable line_length
public class Storj {
    //
    //
    var parseAccessFunc: ParseAccess?, requestAccessWithPassphraseFunc: RequestAccessWithPassphrase?, accessSerializeFunc: AccessSerialize?, accessShareFunc: AccessShare?
    //
    var freeStringResultFunc: FreeStringResult?, freeAccessResultFunc: FreeAccessResult?, statBucketFunc: StatBucket?, createBucketFunc: CreateBucket?
    //
    var ensureBucketFunc: EnsureBucket?, deleteBucketFunc: DeleteBucket?, listBucketsFunc: ListBuckets?
    //
    var bucketIteratorNextFunc: BucketIteratorNext?, bucketIteratorErrorFunc: BucketIteratorErr?, bucketIteratorItemFunc: BucketIteratorItem?

    //
    var freeBucketIteratorFunc: FreeBucketIterator?, configRequestAccessWithPassphraseFunc: ConfigRequestAccessWithPassphrase?, configOpenProjectFunc: ConfigOpenProject?

    //
    var downloadObjectFunc: DownloadObject?, downloadReadFunc: DownloadRead?, freeDownloadResultFunc: FreeDownloadResult?, downloadInfoFunc: DownloadInfo?

    //
    var uploadInfoFunc: UploadInfo?, freeReadResultFunc: FreeReadResult?, closeDownloadFunc: CloseDownload?, freeBucketResultFunc: FreeBucketResult?, freeErrorFunc: FreeError?

    //
    var statObjectFunc: StatObject?, deleteObjectFunc: DeleteObject?, freeObjectResultFunc: FreeObjectResult?, freeObjectFunc: FreeObject?, listObjectsFunc: ListObjects?

    //
    var objectIteratorNextFunc: ObjectIteratorNext?, objectIteratorErrorFunc: ObjectIteratorErr?, objectIteratorItemFunc: ObjectIteratorItem?

    //
    var freeObjectIteratorFunc: FreeObjectIterator?, openProjectFunc: OpenProject?, closeProjectFunc: CloseProject?

    //
    var freeProjectResultFunc: FreeProjectResult?, uploadObjectFunc: UploadObject?, uploadWriteFunc: UploadWrite?, uploadCommitFunc: UploadCommit?

    //
    var uploadAbortFunc: UploadAbort?, uploadSetCustomMetadataFunc: UploadSetCustomMetadata?

    //
    var freeWriteResultFunc: FreeWriteResult?, freeUploadResultFunc: FreeUploadResult?, freeBucketFunc: FreeBucket?

    //
    var accessOverrideEncryptionKeyFunc: AccessOverrideEncryptionKey?, deriveEncryptionKeyFunc: DeriveEncryptionKey?, freeEncryptionKeyResultFunc: FreeEncryptionKeyResult?

    //
    private static var uplink: Storj?
    //
    public static func uplink(_ libuplinkSOlocation: String = "") throws -> Storj {
        do {
            //Returning Storj Instance
            if Storj.self.uplink != nil {
                return Storj.self.uplink!
            } else {
                //Creating Storj instance
                Storj.self.uplink = try Storj(libuplinkSOlocation)
            }
            return Storj.uplink!
        } catch {
            throw error
        }
    }
    //
    private init(_ libuplinkSOlocation: String = "") throws {
        //
        var storjSwiftPathString: String = ""
        //Default value of libuplinkc.dylib
        if libuplinkSOlocation.isEmpty {
            //
            //Fetching path of uplink-swift file
            let storjswiftPath = URL(fileURLWithPath: #file)
            //
            storjSwiftPathString = storjswiftPath.path
            //
            if !storjSwiftPathString.contains("uplink-swift/") {
                throw storjException(code: 9999, message: "Failed to find package")
            }
            //
            storjSwiftPathString = storjSwiftPathString.components(separatedBy: "Sources/uplink-swift/")[0]
            //
            storjSwiftPathString += "Sources/libuplink/include/libuplinkc.dylib"
            //
        } else {
            storjSwiftPathString = libuplinkSOlocation
        }
        //Checking whether libuplinkc.dylib exits or not
        let fileManger = FileManager.default
        //
        if !fileManger.fileExists(atPath: storjSwiftPathString) {
            throw storjException(code: 9999, message: "Failed to open dylib file")
        }
        // Opening dylib file
        let dynammicFileHandle = dlopen(storjSwiftPathString, RTLD_LOCAL|RTLD_NOW)
        if dynammicFileHandle == nil {
            throw storjException(code: 9999, message: "Failed to open dylib file")
        }
        do {
            // Loading function from .dylib file
            try loadAccessSym(dynammicFileHandle: dynammicFileHandle)
            try loadProjectSym(dynammicFileHandle: dynammicFileHandle)
            try loadBucketSym(dynammicFileHandle: dynammicFileHandle)
            try loadBucketListSym(dynammicFileHandle: dynammicFileHandle)
            try loadObjectSym(dynammicFileHandle: dynammicFileHandle)
            try loadObjectListSym(dynammicFileHandle: dynammicFileHandle)
            try loadUploadSym(dynammicFileHandle: dynammicFileHandle)
            try loadDownloadSym(dynammicFileHandle: dynammicFileHandle)
            try loadErrorSym(dynammicFileHandle: dynammicFileHandle)
            try loadEncryptionSym(dynammicFileHandle: dynammicFileHandle)
            try checkAllFunction()
            //
        } catch {
            throw error
        }
    }
    //
    //
    // request_Access_With_Passphrase generates a new access grant using a passhprase.
    // It must talk to the Satellite provided to get a project-based salt for deterministic
    // key derivation.
    // Note: this is a CPU-heavy function that uses a password-based key derivation
    // function (Argon2). This should be a setup-only step.
    // Most common interactions with the library should be using a serialized access grant
    // through ParseAccess directly.
    // Input : Satellite Address (String) , API key (String) , Encryption phassphrase(String)
    // Output : Access (Object)
    public func request_Access_With_Passphrase(satellite: String, apiKey: String, encryption: String)throws -> (AccessResultStr) {
        do {
        // Creating pointer of string
        let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: (satellite as NSString).utf8String)
        let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: (apiKey as NSString).utf8String)
        let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: (encryption as NSString).utf8String)
        //
        let accessResult = (self.requestAccessWithPassphraseFunc!)(ptrSatelliteAddress, ptrAPIKey, ptrEncryptionPassphrase)
        //
        if accessResult.access != nil {
            return AccessResultStr(uplink: Storj.uplink!, access: accessResult.access.pointee, accessResult: accessResult)

        } else {
            if accessResult.error != nil {
                throw storjException(code: Int(accessResult.error.pointee.code), message: String(validatingUTF8: (accessResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Error request_Access_With_Passphrase ")
                }
            }
        } catch {
            throw error
        }
    }
    //
    // parse_Access parses a serialized access grant string.
    // This should be the main way to instantiate an access grant for opening a project.
    // See the note on RequestAccessWithPassphrase
    // Input : Shared string
    // Output : Access (Object)
    public func parse_Access(stringKey: String)throws -> (AccessResultStr) {
        do {
            //
            let ptrStringKey = UnsafeMutablePointer<CChar>(mutating: (stringKey as NSString).utf8String)
            let accessResult = self.parseAccessFunc!(ptrStringKey)
            //
            if accessResult.access != nil {
                return AccessResultStr(uplink: Storj.uplink!, access: accessResult.access.pointee, accessResult: accessResult)
            } else {
                if accessResult.error != nil {
                    throw storjException(code: Int(accessResult.error.pointee.code), message: String(validatingUTF8: (accessResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Error parse_Access ")
                }
            }
        } catch {
            throw error
        }
    }
    //
    // config_Request_Access_With_Passphrase generates a new access grant using a passhprase and custom configuration.
    // It must talk to the Satellite provided to get a project-based salt for deterministic key derivation.
    // Note: this is a CPU-heavy function that uses a password-based key derivation function (Argon2). This should be a setup-only step.
    // Most common interactions with the library should be using a serialized access grant
    // hrough ParseAccess directly.
    // Input : Config (ConfigInfo) , Satellite Address (String) , API key (String) , Encryption phassphrase(String)
    // Output : Access (Object)
    public func config_Request_Access_With_Passphrase(config: Config, satelliteAddress: String, apiKey: String, encryptionPassphrase: String)throws -> (AccessResultStr) {
        do {
            //
            var configUplink: UplinkConfig = UplinkConfig()
            configUplink.dial_timeout_milliseconds = config.dial_timeout_milliseconds
            configUplink.temp_directory = UnsafePointer<CChar>((config.temp_directory as NSString).utf8String)
            configUplink.user_agent = UnsafePointer<CChar>((config.user_agent as NSString).utf8String)
            //
            let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: (satelliteAddress as NSString).utf8String)
            let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: (apiKey as NSString).utf8String)
            let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: (encryptionPassphrase as NSString).utf8String)
            //
            let accessResult = self.configRequestAccessWithPassphraseFunc!(configUplink, ptrSatelliteAddress, ptrAPIKey, ptrEncryptionPassphrase)
            //
            if accessResult.access != nil {
                return AccessResultStr(uplink: Storj.uplink!, access: accessResult.access.pointee, accessResult: accessResult)
            } else {
               if accessResult.error != nil {
                   throw storjException(code: Int(accessResult.error.pointee.code), message: String(validatingUTF8: (accessResult.error.pointee.message!))!)
               } else {
                   throw storjException(code: 9999, message: "Error config_Request_Access_With_Passphrase ")
               }
           }
        } catch {
            throw error
        }
    }
    //
    // function derives a salted encryption key for passphrase using the
    // salt.
    // This function is useful for deriving a salted encryption key for users when
    // implementing multitenancy in a single app bucket.
    // Input passphrase (String) and salt (inout [UInt8])
    // Output UplinkEncryptionKey (Object)
    public func derive_Encryption_Key(passphrase: String, salt: inout [UInt8])throws -> (UplinkEncryptionKeyResult) {
        do {
            //
            let ptrpassphrase = UnsafePointer<CChar>((passphrase as NSString).utf8String)!
            let ptrSalt = salt.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
            let lenght = salt.count
            let encryptionResult = self.deriveEncryptionKeyFunc!(ptrpassphrase, ptrSalt, lenght)
            //
            if encryptionResult.encryption_key != nil {
                return encryptionResult
            } else {
                if encryptionResult.error != nil {
                    throw storjException(code: Int(encryptionResult.error.pointee.code), message: String(validatingUTF8: (encryptionResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Error derive_Encryption_Key ")
                }
            }
        } catch {
            throw error
        }
    }
    //
    // function frees the resources associated with encryption key.
    // Input : encryptionResult (inout UplinkEncryptionKeyResult)
    // Output : None
    public func free_Encryption_Key_Result(encryptionResult: inout UplinkEncryptionKeyResult) {
        self.freeEncryptionKeyResultFunc!(encryptionResult)
    }
}
