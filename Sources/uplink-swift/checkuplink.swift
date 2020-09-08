import Foundation

extension Storj {
    //
    //swiftlint:disable cyclomatic_complexity function_body_length
    func checkAllFunction() throws {
        //
        if self.parseAccessFunc == nil {
            throw storjException(code: 9999, message: "Failed to load parse Access function")
        }
        //
        if self.requestAccessWithPassphraseFunc == nil {
            throw storjException(code: 9999, message: "Failed to load request accesss function")
        }
        //
        if self.accessSerializeFunc == nil {
            throw storjException(code: 9999, message: "Failed to load access Serilize function")
        }
        //
        if self.accessShareFunc == nil {
            throw storjException(code: 9999, message: "Failed to load access Share function")
        }
        //
        if self.freeStringResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free string result function")
        }
        //
        if self.freeAccessResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free access result function")
        }
        //
        if self.statBucketFunc == nil {
            throw storjException(code: 9999, message: "Failed to load stat bucket function")
        }
        //
        if self.createBucketFunc == nil {
            throw storjException(code: 9999, message: "Failed to load create bucket function")
        }
        //
        if self.ensureBucketFunc == nil {
            throw storjException(code: 9999, message: "Failed to load ensure bucket function")
        }
        //
        if self.deleteBucketFunc == nil {
            throw storjException(code: 9999, message: "Failed to load delete bucket function")
        }
        //
        if self.listBucketsFunc == nil {
            throw storjException(code: 9999, message: "Failed to load list buckets function")
        }
        //
        if self.bucketIteratorNextFunc == nil {
            throw storjException(code: 9999, message: "Failed to load bucket iterator function")
        }
        //
        if self.bucketIteratorErrorFunc == nil {
            throw storjException(code: 9999, message: "Failed to load bucket Iterator function")
        }
        //
        if self.bucketIteratorItemFunc == nil {
            throw storjException(code: 9999, message: "Failed to load bucket Interator Item function")
        }
        //
        if self.freeBucketIteratorFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free Bucket Iterator function")
        }
        //
        if self.configRequestAccessWithPassphraseFunc == nil {
            throw storjException(code: 9999, message: "Failed to load requestion access with config function")
        }
        //
        if self.configOpenProjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load open project using config function")
        }
        //
        if self.downloadObjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load download Object function")
        }
        //
        if self.downloadReadFunc == nil {
            throw storjException(code: 9999, message: "Failed to load download read function")
        }
        //
        if self.freeDownloadResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free download result function")
        }
        //
        if self.downloadInfoFunc == nil {
            throw storjException(code: 9999, message: "Failed to load download info function")
        }
        //
        if self.uploadInfoFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload info function")
        }
        //
        if self.freeReadResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free Read Iterator function")
        }
        //
        if self.closeDownloadFunc == nil {
            throw storjException(code: 9999, message: "Failed to load close download function")
        }
        //
        if self.freeErrorFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free Error Result function")
        }
        //
        if self.statObjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load stat Object function")
        }
        //
        if self.deleteObjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load delete Object function")
        }
        //
        if self.freeObjectResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free Object Result function")
        }
        //
        if self.freeObjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free Object function")
        }
        //
        if self.listObjectsFunc == nil {
            throw storjException(code: 9999, message: "Failed to load list Object function")
        }
        //
        if self.objectIteratorErrorFunc == nil {
            throw storjException(code: 9999, message: "Failed to load object Iterator function")
        }
        //
        if self.objectIteratorItemFunc == nil {
            throw storjException(code: 9999, message: "Failed to load object Item function")
        }
        //
        if self.freeObjectIteratorFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free object Iterator Func function")
        }
        //
        if self.openProjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load open project function")
        }
        //
        if self.closeProjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load close project function")
        }
        //
        if self.freeProjectResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free project function")
        }
        //
        if self.uploadObjectFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload object function")
        }
        //
        if self.uploadWriteFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload write function")
        }
        //
        if self.uploadCommitFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload commit function")
        }
        //
        if self.uploadAbortFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload abort function")
        }
        //
        if self.uploadSetCustomMetadataFunc == nil {
            throw storjException(code: 9999, message: "Failed to load upload custom metadata function")
        }
        //
        if self.freeWriteResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free write result function")
        }
        //
        if self.freeUploadResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free upload result function")
        }
        //
        if self.freeBucketFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free upload bucket function")
        }
        //
        if self.accessOverrideEncryptionKeyFunc == nil {
            throw storjException(code: 9999, message: "Failed to load access override encryption key function")
        }
        //
        if self.deriveEncryptionKeyFunc == nil {
            throw storjException(code: 9999, message: "Failed to load derive encryption key function")
        }
        //
        if self.freeEncryptionKeyResultFunc == nil {
            throw storjException(code: 9999, message: "Failed to load free encryption key result function")
        }
    }
}
