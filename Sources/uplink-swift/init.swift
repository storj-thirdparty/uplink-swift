import Foundation
import libuplink

extension Storj {
    mutating func loadErrorSym() throws {
        let sym = dlsym(self.dynammicFileHandle, "free_error")
        if sym != nil {
            self.freeErrorFunc = unsafeBitCast(sym, to: FreeError.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    mutating func loadUploadSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "upload_object")
        if sym != nil {
            self.uploadObjectFunc = unsafeBitCast(sym, to: UploadObject.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "upload_write")
        if sym != nil {
            self.uploadWriteFunc = unsafeBitCast(sym, to: UploadWrite.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "upload_commit")
        if sym != nil {
            self.uploadCommitFunc = unsafeBitCast(sym, to: UploadCommit.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "upload_abort")
        if sym != nil {
            self.uploadAbortFunc = unsafeBitCast(sym, to: UploadAbort.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "upload_set_custom_metadata")
        if sym != nil {
            self.uploadSetCustomMetadataFunc = unsafeBitCast(sym, to: UploadSetCustomMetadata.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_write_result")
        if sym != nil {
            self.freeWriteResultFunc = unsafeBitCast(sym, to: FreeWriteResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_upload_result")
        if sym != nil {
            self.freeUploadResultFunc = unsafeBitCast(sym, to: FreeUploadResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "upload_info")
        if sym != nil {
            self.uploadInfoFunc = unsafeBitCast(sym, to: UploadInfo.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    mutating func loadBucketSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "stat_bucket")
        if sym != nil {
            self.statBucketFunc = unsafeBitCast(sym, to: StatBucket.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "create_bucket")
        if sym != nil {
            self.createBucketFunc = unsafeBitCast(sym, to: CreateBucket.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "ensure_bucket")
        if sym != nil {
            self.ensureBucketFunc = unsafeBitCast(sym, to: EnsureBucket.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "delete_bucket")
        if sym != nil {
            self.deleteBucketFunc = unsafeBitCast(sym, to: DeleteBucket.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "free_bucket")
        if sym != nil {
            self.freeBucketFunc = unsafeBitCast(sym, to: FreeBucket.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "free_bucket_result")
        if sym != nil {
            self.freeBucketResultFunc = unsafeBitCast(sym, to: FreeBucketResult.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    mutating func loadDownloadSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "download_object")
        if sym != nil {
            self.downloadObjectFunc = unsafeBitCast(sym, to: DownloadObject.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "download_read")
        if sym != nil {
            self.downloadReadFunc = unsafeBitCast(sym, to: DownloadRead.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_download_result")
        if sym != nil {
            self.freeDownloadResultFunc = unsafeBitCast(sym, to: FreeDownloadResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "download_info")
        if sym != nil {
            self.downloadInfoFunc = unsafeBitCast(sym, to: DownloadInfo.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_read_result")
        if sym != nil {
            self.freeReadResultFunc = unsafeBitCast(sym, to: FreeReadResult.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "close_download")
        if sym != nil {
            self.closeDownloadFunc = unsafeBitCast(sym, to: CloseDownload.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    //
    mutating func loadBucketListSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "list_buckets")
        if sym != nil {
            self.listBucketsFunc = unsafeBitCast(sym, to: ListBuckets.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "bucket_iterator_next")
        if sym != nil {
            self.bucketIteratorNextFunc = unsafeBitCast(sym, to: BucketIteratorNext.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "bucket_iterator_item")
        if sym != nil {
            self.bucketIteratorItemFunc = unsafeBitCast(sym, to: BucketIteratorItem.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "bucket_iterator_err")
        if sym != nil {
            self.bucketIteratorErrorFunc = unsafeBitCast(sym, to: BucketIteratorErr.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "free_bucket_iterator")
        if sym != nil {
            self.freeBucketIteratorFunc = unsafeBitCast(sym, to: FreeBucketIterator.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    //
    mutating func loadObjectListSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "free_object")
        if sym != nil {
            self.freeObjectFunc = unsafeBitCast(sym, to: FreeObject.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "list_objects")
        if sym != nil {
            self.listObjectsFunc = unsafeBitCast(sym, to: ListObjects.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "object_iterator_next")
        if sym != nil {
            self.objectIteratorNextFunc = unsafeBitCast(sym, to: ObjectIteratorNext.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "object_iterator_err")
        if sym != nil {
            self.objectIteratorErrorFunc = unsafeBitCast(sym, to: ObjectIteratorErr.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "object_iterator_item")
        if sym != nil {
            self.objectIteratorItemFunc = unsafeBitCast(sym, to: ObjectIteratorItem.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "free_object_iterator")
        if sym != nil {
            self.freeObjectIteratorFunc = unsafeBitCast(sym, to: FreeObjectIterator.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    mutating func loadAccessSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "request_access_with_passphrase")
        if sym != nil {
            self.requestAccessWithPassphraseFunc = unsafeBitCast(sym, to: RequestAccessWithPassphrase.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "parse_access")
        if sym != nil {
            self.parseAccessFunc = unsafeBitCast(sym, to: ParseAccess.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "access_serialize")
        if sym != nil {
            self.accessSerializeFunc = unsafeBitCast(sym, to: AccessSerialize.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "access_share")
        if sym != nil {
            self.accessShareFunc = unsafeBitCast(sym, to: AccessShare.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_string_result")
        if sym != nil {
            self.freeStringResultFunc = unsafeBitCast(sym, to: FreeStringResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_access_result")
        if sym != nil {
            self.freeAccessResultFunc = unsafeBitCast(sym, to: FreeAccessResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "config_request_access_with_passphrase")
        if sym != nil {
            self.configRequestAccessWithPassphraseFunc = unsafeBitCast(sym, to: ConfigRequestAccessWithPassphrase.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    //
    mutating func loadProjectSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "open_project")
        if sym != nil {
            self.openProjectFunc = unsafeBitCast(sym, to: OpenProject.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "close_project")
        if sym != nil {
            self.closeProjectFunc = unsafeBitCast(sym, to: CloseProject.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "free_project_result")
        if sym != nil {
            self.freeProjectResultFunc = unsafeBitCast(sym, to: FreeProjectResult.self)
        } else {
            throw self.failToFoundFunction
        }
        //
        sym = dlsym(self.dynammicFileHandle, "config_open_project")
        if sym != nil {
            self.configOpenProjectFunc = unsafeBitCast(sym, to: ConfigOpenProject.self)
        } else {
            throw self.failToFoundFunction
        }
    }
    mutating func loadObjectSym() throws {
        var sym = dlsym(self.dynammicFileHandle, "stat_object")
        if sym != nil {
            self.statObjectFunc = unsafeBitCast(sym, to: StatObject.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "delete_object")
        if sym != nil {
            self.deleteObjectFunc = unsafeBitCast(sym, to: DeleteObject.self)
        } else {
            throw self.failToFoundFunction
        }
        sym = dlsym(self.dynammicFileHandle, "free_object_result")
        if sym != nil {
            self.freeObjectResultFunc = unsafeBitCast(sym, to: FreeObjectResult.self)
        } else {
            throw self.failToFoundFunction
        }
    }
}
