import Foundation
import libuplink

//swiftlint:disable line_length identifier_name
public func uplinkObjectToSwift(uplinkObject: Object) -> (UplinkObject) {
    //
    let key: String = String(validatingUTF8: (uplinkObject.key!))!
    let is_prefix: Bool = uplinkObject.is_prefix
    //
    let system: SystemMetadata = uplinkObject.system
    //
    let custom: CustomMetadata = uplinkObject.custom
    //
    let systemStr: UplinkSystemMetadata = UplinkSystemMetadata()
    systemStr.content_length = system.content_length
    systemStr.created = system.created
    systemStr.expires = system.expires
    //
    var customMetaArray: [UplinkCustomMetadataEntry] = []
    var metaData: UplinkCustomMetadata
    //
    if custom.count>0 {
        //
        let buffer = UnsafeBufferPointer(start: custom.entries, count: custom.count)
        let entriesArray = Array(buffer)
        for entries in entriesArray {
            let entry = UplinkCustomMetadataEntry(key: String(validatingUTF8: (entries.key!))!, key_length: entries.key_length, value: String(validatingUTF8: (entries.value!))!, value_length: entries.value_length)
            customMetaArray.append(entry)
        }
        metaData = UplinkCustomMetadata(entries: customMetaArray, count: custom.count)
        return UplinkObject(key: key, is_prefix: is_prefix, system: systemStr, custom: metaData)
    }
    // Return object
    return UplinkObject(key: key, is_prefix: is_prefix, system: systemStr, custom: UplinkCustomMetadata(entries: [], count: 0))
}
//
extension ProjectResultStr {
    //
    // function returns information about an object at the specific key.
    //Input : BucketName (String) , ObjectName (String)
    //Output : UplinkObject (Object)
    public func stat_Object(bucket: String, key: String) throws ->(UplinkObject) {
        do {
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: (key as NSString).utf8String)
            let objectResult = self.uplink.statObjectFunc!(&self.project, ptrBucketName, ptrStorjObjectName)
            //
            if objectResult.object != nil {
                return uplinkObjectToSwift(uplinkObject: objectResult.object.pointee)
            }
            //
            defer {
                self.uplink.freeObjectResultFunc!(objectResult)
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
    // function starts an upload to the specified key.
    // Iutput : Bucket Name (String) , ObjectPath (String) and Download Options (Object)
    // Output : UploadResultStr (Object)
    public func upload_Object(bucket: String, key: String, uploadOptions:inout UplinkUploadOptions) throws ->(UploadResultStr) {
        do {
            //
            var uploadOptionsUplink = UploadOptions()
            uploadOptionsUplink.expires = uploadOptions.expires
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: (key as NSString).utf8String)
            //
            let uploadResult = self.uplink.uploadObjectFunc!(&self.project, ptrBucketName, ptrStorjObjectName, &uploadOptionsUplink)
            //
            if uploadResult.upload != nil {
                return UploadResultStr(uplink: self.uplink, upload: uploadResult.upload.pointee, uploadResult: uploadResult)
            } else {
                if uploadResult.error != nil {
                throw storjException(code: Int(uploadResult.error.pointee.code), message: String(validatingUTF8: (uploadResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Upload Object and error is nil")
                }
            }
        } catch {
            throw error
        }
    }
    //
    // function starts download to the specified key.
    // Iutput : Bucket Name (String) , ObjectPath (String) and Download Options (Object)
    // Output : Download (Object)
    public func download_Object(bucket: String, key: String, downloadOptions:inout  UplinkDownloadOptions) throws ->(DownloadResultStr) {
        do {
            var downloadOptionsUplink = DownloadOptions()
            downloadOptionsUplink.length = downloadOptions.length
            downloadOptionsUplink.offset = downloadOptions.offset
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: (key as NSString).utf8String)
            //
            let downloadResult = self.uplink.downloadObjectFunc!(&self.project, ptrBucketName, ptrStorjObjectName, &downloadOptionsUplink)
            //
            if downloadResult.download != nil {
                return DownloadResultStr(uplink: self.uplink, download: downloadResult.download.pointee)
            } else {
                if downloadResult.error != nil {
                throw storjException(code: Int(downloadResult.error.pointee.code), message: String(validatingUTF8: (downloadResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Download object and error is nil")
                }
            }
        } catch {
            throw error
        }
    }
    //
    //function deletes the object at the specific key.
    //Input : BucketName (String) , ObjectName (String)
    //Output : ObjectInfo (Object)
    public func delete_Object(bucket: String, key: String) throws ->(UplinkObject) {
        do {

            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: (key as NSString).utf8String)
            let objectResult = self.uplink.deleteObjectFunc!(&self.project, ptrBucketName, ptrStorjObjectName)
            //
            defer {
                self.uplink.freeObjectResultFunc!(objectResult)
            }
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
    //function returns a list of objects with all its information.
    //Input : BucketName (String) , ListObjectOptions (Object)
    //Output : UplinkObject (Object)
    public func list_Objects(bucket: String, listObjectsOptions:inout  UplinkListObjectsOptions) throws->([UplinkObject]) {
        do {
            //
            var listObjectsOptionsUplink = ListObjectsOptions()
            //
            listObjectsOptionsUplink.prefix = UnsafeMutablePointer<CChar>(mutating: (listObjectsOptions.prefix as NSString).utf8String)
            listObjectsOptionsUplink.cursor = UnsafeMutablePointer<CChar>(mutating: (listObjectsOptions.cursor as NSString).utf8String)
            //
            listObjectsOptionsUplink.recursive = listObjectsOptions.recursive
            listObjectsOptionsUplink.system = listObjectsOptions.system
            listObjectsOptionsUplink.custom = listObjectsOptions.custom
            //
            let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            var listObject: [UplinkObject] = []
            var objectIterator =
                self.uplink.listObjectsFunc!(&self.project, ptrToBucketName, &listObjectsOptionsUplink)

            defer {
                if objectIterator != nil {
                    self.uplink.freeObjectIteratorFunc!(objectIterator!)
                }
            }
            if objectIterator != nil {
                while self.uplink.objectIteratorNextFunc!(objectIterator!) {
                    let object = self.uplink.objectIteratorItemFunc!(objectIterator!)
                    if object != nil {
                        listObject.append(uplinkObjectToSwift(uplinkObject: object!.pointee))
                        self.uplink.freeObjectFunc!(object!)
                    }
                }
                //
                var error = self.uplink.objectIteratorErrorFunc!(objectIterator!)
                defer {
                    if error != nil {
                        self.uplink.freeErrorFunc!(error!)

                    }
                }
                if error != nil {
                    throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
                }
            }
            //free object ilterator
            return listObject
        } catch {
           throw error
        }
    }
}
