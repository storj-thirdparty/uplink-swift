import Foundation
import libuplink

//swiftlint:disable line_length identifier_name
public func uplinkObjectToSwift(uplinkObject: UplinkObject) -> (Object) {
    //
    let key: String = String(validatingUTF8: (uplinkObject.key!))!
    let is_prefix: Bool = uplinkObject.is_prefix
    //
    let system: UplinkSystemMetadata = uplinkObject.system
    //
    let custom: UplinkCustomMetadata = uplinkObject.custom
    //
    let systemStr: SystemMetadata = SystemMetadata()
    systemStr.content_length = system.content_length
    systemStr.created = system.created
    systemStr.expires = system.expires
    //
    var customMetaArray: [CustomMetadataEntry] = []
    var metaData: CustomMetadata
    //
    if custom.count>0 {
        //
        let buffer = UnsafeBufferPointer(start: custom.entries, count: custom.count)
        let entriesArray = Array(buffer)
        for entries in entriesArray {
            let entry = CustomMetadataEntry(key: String(validatingUTF8: (entries.key!))!, key_length: entries.key_length, value: String(validatingUTF8: (entries.value!))!, value_length: entries.value_length)
            customMetaArray.append(entry)
        }
        metaData = CustomMetadata(entries: customMetaArray, count: custom.count)
        return Object(key: key, is_prefix: is_prefix, system: systemStr, custom: metaData)
    }
    // Return object
    return Object(key: key, is_prefix: is_prefix, system: systemStr, custom: CustomMetadata(entries: [], count: 0))
}
//
extension ProjectResultStr {
    //
    // function returns information about an object at the specific key.
    //Input : BucketName (String) , ObjectName (String)
    //Output : UplinkObject (Object)
    public func stat_Object(bucket: String, key: String) throws ->(Object) {
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
            return Object(key: "", is_prefix: false, system: SystemMetadata(), custom: CustomMetadata(entries: [], count: 0))

        } catch {
            throw error
        }
    }
    //
    // function starts an upload to the specified key.
    // Iutput : Bucket Name (String) , ObjectPath (String) and Download Options (Object)
    // Output : UploadResultStr (Object)
    public func upload_Object(bucket: String, key: String, uploadOptions:inout UploadOptions) throws ->(UploadResultStr) {
        do {
            //
            var uploadOptionsUplink = UplinkUploadOptions()
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
    public func download_Object(bucket: String, key: String, downloadOptions:inout  DownloadOptions) throws ->(DownloadResultStr) {
        do {
            var downloadOptionsUplink = UplinkDownloadOptions()
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
    public func delete_Object(bucket: String, key: String) throws ->(Object) {
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
            return Object(key: "", is_prefix: false, system: SystemMetadata(), custom: CustomMetadata(entries: [], count: 0))
        } catch {
            throw error
        }
    }
    //
    //function returns a list of objects with all its information.
    //Input : BucketName (String) , ListObjectOptions (Object)
    //Output : UplinkObject (Object)
    public func list_Objects(bucket: String, listObjectsOptions:inout  ListObjectsOptions) throws->([Object]) {
        do {
            //
            var listObjectsOptionsUplink = UplinkListObjectsOptions()
            //
            listObjectsOptionsUplink.prefix = UnsafePointer<CChar>((listObjectsOptions.prefix as NSString).utf8String)
            listObjectsOptionsUplink.cursor = UnsafePointer<CChar>((listObjectsOptions.cursor as NSString).utf8String)
            //
            listObjectsOptionsUplink.recursive = listObjectsOptions.recursive
            listObjectsOptionsUplink.system = listObjectsOptions.system
            listObjectsOptionsUplink.custom = listObjectsOptions.custom
            //
            let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            var listObject: [Object] = []
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
