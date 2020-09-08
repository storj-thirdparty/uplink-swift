import Foundation
import libuplink

//swiftlint:disable line_length
public class AccessResultStr {
    //
    var access: UplinkAccess
    var uplink: Storj
    var accessResult: UplinkAccessResult?
    //
    public init(uplink: Storj, access: UplinkAccess, accessResult: UplinkAccessResult? = nil) {
        self.access = access
        self.uplink = uplink
        if accessResult != nil {
            self.accessResult = accessResult
        }
    }
    //
    //function serializes an access grant such that it can be used later with ParseAccess or other tools.
    //Input : None
    //Output : SharedString (String)
    public func serialize()throws -> (String) {
        do {
            let stringResult = uplink.accessSerializeFunc!(&self.access)
            defer {
                self.uplink.freeStringResultFunc!(stringResult)
            }
            //
            if stringResult.string != nil {
                return String(validatingUTF8: stringResult.string)!
            } else {
                if stringResult.error != nil {
                    throw storjException(code: Int(stringResult.error.pointee.code), message: String(validatingUTF8: (stringResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Serialized string and error object is nil")
                }
            }
        } catch {
           throw error
        }
    }
    //
    //function opens Storj(V3) project using access grant.
    //Input : None
    //Output : ProjectResultStr(Object)
    public func open_Project()throws ->(ProjectResultStr) {
        do {
            let projectResult = self.uplink.openProjectFunc!(&self.access)
            //
            if projectResult.project != nil {
                return ProjectResultStr(uplink: self.uplink, project: projectResult.project.pointee, projectResult: projectResult)
            } else {
                //
                if projectResult.error != nil {
                    throw storjException(code: Int(projectResult.error.pointee.code), message: String(validatingUTF8: (projectResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Project and error object is nil")
                }
            }
        } catch {
            throw error
        }
    }
    //
    //function opens Storj(V3) project using access grant and custom configuration.
    //Input : None
    //Output : ProjectResultStr(Object)
    public func config_Open_Project(config: Config)throws ->(ProjectResultStr) {
        do {
            //
            var configUplink = UplinkConfig()
            configUplink.dial_timeout_milliseconds = config.dial_timeout_milliseconds
            configUplink.temp_directory = UnsafePointer<CChar>((config.temp_directory as NSString).utf8String)
            configUplink.user_agent = UnsafePointer<CChar>((config.user_agent as NSString).utf8String)
            //
            let projectResult = uplink.configOpenProjectFunc!(configUplink, &self.access)
            //
            if projectResult.project != nil {
                return ProjectResultStr(uplink: self.uplink, project: projectResult.project.pointee, projectResult: projectResult)
                //
            } else {
                //
                if projectResult.error != nil {
                    throw storjException(code: Int(projectResult.error.pointee.code), message: String(validatingUTF8: (projectResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Project and error object is nil")
                }
            }
        } catch {
            throw error
        }
    }
    //
    //function Share creates a new access grant with specific permissions.
    //Access grants can only have their existing permissions restricted, and the resulting
    //access grant will only allow for the intersection of all previous Share calls in the
    //access grant construction chain.
    //Prefixes, if provided, restrict the access grant (and internal encryption information)
    //to only contain enough information to allow access to just those prefixes.
    //Input : Permission (Object) , sharePrefixListArray (Array) , sharePrefixListArraylength (Int)
    //Output : AccessResultStr(Object)
    public func share(permission:inout Permission, prefix:inout [SharePrefix])throws ->(AccessResultStr) {
        //
        var permissionUplink = UplinkPermission()
        permissionUplink.allow_download = permission.allow_download
        permissionUplink.allow_upload = permission.allow_upload
        permissionUplink.allow_list = permission.allow_list
        permissionUplink.allow_delete = permission.allow_delete
        permissionUplink.not_after = permission.not_after
        permissionUplink.not_before = permission.not_before
        //
        var sharePrefixArray: [UplinkSharePrefix] = []
        for sharePrefix in prefix {
            //
            var sharePrefixUplink = UplinkSharePrefix()
            //
            //
            sharePrefixUplink.bucket = UnsafePointer<CChar>((sharePrefix.bucket as NSString).utf8String)
            //
            sharePrefixUplink.prefix = UnsafePointer<CChar>((sharePrefix.prefix as NSString).utf8String)
            //
            sharePrefixArray.append(sharePrefixUplink)
        }
        //
        let ptrTosharePrefix = UnsafeMutablePointer<UplinkSharePrefix>.allocate(capacity: sharePrefixArray.count)
        //
        ptrTosharePrefix.initialize(from: &sharePrefixArray, count: sharePrefixArray.count)
        //
        let accessResult = self.uplink.accessShareFunc!(&self.access, permissionUplink, ptrTosharePrefix, GoInt(sharePrefixArray.count))
        //
        //
        if accessResult.access != nil {
            let accessResultStr = AccessResultStr(uplink: self.uplink, access: accessResult.access.pointee, accessResult: accessResult)
             return accessResultStr
        } else {
            if accessResult.error != nil {
                throw storjException(code: Int(accessResult.error.pointee.code), message: String(validatingUTF8: (accessResult.error.pointee.message!))!)
            } else {
                throw storjException(code: 9999, message: "Access and error object is nil")
            }
        }
        //
    }
    //
    // function overrides the root encryption key for the prefix in
    // bucket with encryptionKey.
    // This function is useful for overriding the encryption key in user-specific
    // access grants when implementing multitenancy in a single app bucket.
    // Input : bucket (String) , prefix (String) and encryptionKey (UplinkEncryptionKeyResult)
    // Output : None
    public func access_Override_Encryption_Key(bucket: String, prefix: String, encryptionKey: UplinkEncryptionKeyResult)throws {
        do {
            let ptrbucket = UnsafePointer<CChar>((bucket as NSString).utf8String)
            let ptrprefix = UnsafePointer<CChar>((prefix as NSString).utf8String)
            let error = self.uplink.accessOverrideEncryptionKeyFunc!(&self.access, ptrbucket!, ptrprefix!, encryptionKey.encryption_key)
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
        } catch {
            throw error
        }
    }
}
