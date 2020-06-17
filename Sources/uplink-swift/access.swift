import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    mutating public func request_Access_With_Passphrase(satellite: NSString, apiKey: NSString, encryption: NSString)throws -> (AccessResult) {
        let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: satellite.utf8String)
        let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
        let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: encryption.utf8String)
        let accessResult = (self.requestAccessWithPassphraseFunc!)(ptrSatelliteAddress, ptrAPIKey, ptrEncryptionPassphrase)
        return accessResult
    }

    //* function to parses serialized access grant string
    //* pre-requisites: None
    //* inputs: StringKey
    //* output: AccessResult
     mutating public func parse_Access(stringKey: NSString)throws -> (AccessResult) {
         let ptrStringKey = UnsafeMutablePointer<CChar>(mutating: stringKey.utf8String)
         let accessResult = self.parseAccessFunc!(ptrStringKey)
         return accessResult
     }
    //
    //* function requests satellite for a new access grant using a passhprase and config.
    //* pre-requisites: None
    //* inputs: None
    //* output: AccessResult
    mutating public func config_Request_Access_With_Passphrase(config: Config, satelliteAddress: NSString, apiKey: NSString, encryptionPassphrase: NSString)throws -> (AccessResult) {
           let ptrSatelliteAddress = UnsafeMutablePointer<CChar>(mutating: satelliteAddress.utf8String)
           let ptrAPIKey = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
           let ptrEncryptionPassphrase = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
           let accessResult = self.configRequestAccessWithPassphraseFunc!(config, ptrSatelliteAddress, ptrAPIKey, ptrEncryptionPassphrase)
           return accessResult
    }
    //
    //* function to serializes access grant into a string.
    //* pre-requisites: None
    //* inputs: Access
    //* output: StringResult
    mutating public func access_Serialize(access:inout Access)throws -> (StringResult) {
       let stringResult = self.accessSerializeFunc!(&access)
       return stringResult
   }
    //
    //* function frees memory associated with the AccessResult.
    //* pre-requisites: None
    //* inputs: AccessResult
    //* output: None
   mutating public func free_Access_Result(accessResult:inout AccessResult)throws {
       self.freeAccessResultFunc!(accessResult)
   }
    //
    //* function creates new access grant with specific permission. Permission will be applied to prefixes when defined.
    //* pre-requisites: None
    //* inputs: None
    //* output: AccessResult
    mutating public func access_Share(access:inout UnsafeMutablePointer<Access>, permission:inout Permission, prefix:inout UnsafeMutablePointer<SharePrefix>, prefixCount: Int)throws ->(AccessResult) {
        let accessResult = self.accessShareFunc!(access, permission, prefix, GoInt(prefixCount))
        return accessResult
    }
    //
    //* function to free memory associated with the StringResult
    //* pre-requisites: None
    //* inputs: StringResult
    //* output: None
     mutating public func free_String_Result(stringResult:inout StringResult)throws {
         self.freeStringResultFunc!(stringResult)
     }
}
