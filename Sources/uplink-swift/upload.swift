import Foundation
import libuplink

//swiftlint:disable line_length
public class UploadResultStr {
    var upload: Upload
    var uplink: Storj
    var uploadResult: UploadResult?
    //
    //
    public init(uplink: Storj, upload: Upload, uploadResult: UploadResult? = nil) {
        self.upload = upload
        self.uplink = uplink
        if uploadResult != nil {
            self.uploadResult = uploadResult
        }
    }
    //
    // function uploads bytes data passed as parameter to the object's data stream.
    // Input : Buffer (UnsafeMutablePointer<UInt8>), Buffer length (Int)
    // Output : WriteResult (Int)
    public func write(data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int) throws ->(Int) {
        do {
            //
            var writeResult = self.uplink.uploadWriteFunc!(&self.upload, data, sizeToWrite)
            //
            defer {
                self.uplink.freeWriteResultFunc!(writeResult)
            }
            //
            if writeResult.error == nil {
                return writeResult.bytes_written
            } else {
                if writeResult.error != nil {
                throw storjException(code: Int(writeResult.error.pointee.code), message: String(validatingUTF8: (writeResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Write result and error is nil")
                }
            }
        } catch {
            throw error
        }
    }
    //
    // function returns the last information about the uploaded object.
    // Input : None
    // Output : ObjectInfo
    public func info() throws ->(UplinkObject) {
        do {
            let objectResult = self.uplink.uploadInfoFunc!(&self.upload)
            //
            if objectResult.object != nil {
                return uplinkObjectToSwift(uplinkObject: objectResult.object.pointee)
            }
            //
            if objectResult.error != nil {
                throw storjException(code: Int(objectResult.error.pointee.code), message: String(validatingUTF8: (objectResult.error.pointee.message!))!)
            }
            //
            return UplinkObject(key: "", is_prefix: false, system: UplinkSystemMetadata(), custom: UplinkCustomMetadata(entries: [], count: 0))
        } catch {
            throw error
        }
    }
    //
    // function aborts an ongoing upload.
    // Input : None
    // Output : ObjectInfo
    public func abort() throws {
        do {
            //
            var error = self.uplink.uploadAbortFunc!(&self.upload)
            //
            defer {
                if error != nil {
                    self.uplink.freeErrorFunc!(error!)

                }
            }
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
            //
        } catch {
            throw error
        }
    }
    //
    // function commits the uploaded data.
    // Input : None
    // Output : None
    public func commit() throws {
        do {
            //
            var error = self.uplink.uploadCommitFunc!(&self.upload)
            //
            defer {
                if error != nil {
                    self.uplink.freeErrorFunc!(error!)
                }
            }
            //
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
        } catch {
            throw error
        }
    }
    //
    // function to set custom meta information while uploading data
    // Input : customMetadata (UplinkCustomMetadata)
    // Output : None
    public func set_Custom_Metadata(customMetadata:inout UplinkCustomMetadata) throws {
        do {

            var entriesArray: [CustomMetadataEntry] = []
            var customMetaDataUplink = CustomMetadata()
            if customMetadata.count > 0 {
                for entry in customMetadata.entries {
                    var customMetaDataUplink = CustomMetadataEntry()
                    customMetaDataUplink.key = UnsafeMutablePointer<CChar>(mutating: (entry.key as NSString).utf8String)
                    customMetaDataUplink.key_length = entry.key_length
                    customMetaDataUplink.value = UnsafeMutablePointer<CChar>(mutating: (entry.value as NSString).utf8String)
                    customMetaDataUplink.value_length = entry.value_length
                    entriesArray.append(customMetaDataUplink)
                }
            }
            //
            let ptrToEntriesArray = UnsafeMutablePointer<CustomMetadataEntry>.allocate(capacity: entriesArray.count)
            //
            ptrToEntriesArray.initialize(from: &entriesArray, count: entriesArray.count)
            //
            customMetaDataUplink.entries = ptrToEntriesArray
            customMetaDataUplink.count = entriesArray.count
            //
            let error = self.uplink.uploadSetCustomMetadataFunc!(&self.upload, customMetaDataUplink)
            //
            defer {
                if error != nil {
                    self.uplink.freeErrorFunc!(error!)

                }
            }
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
        } catch {
            throw error
        }
    }
}
