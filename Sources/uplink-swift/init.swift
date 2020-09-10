import Foundation

import libuplink

//swiftlint:disable line_length
extension Storj {
    // Loading Access function
    func loadAccessSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        do {
            // Request Access With Passphrase
            var sym = dlsym(dynammicFileHandle, "uplink_request_access_with_passphrase")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load request_access_with_passphrase function")
            }
            self.requestAccessWithPassphraseFunc = unsafeBitCast(sym, to: RequestAccessWithPassphrase.self)
            //
            // Free access result function
            sym = dlsym(dynammicFileHandle, "uplink_free_access_result")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load free access result function")
            }
            self.freeAccessResultFunc = unsafeBitCast(sym, to: FreeAccessResult.self)
            //
            // Parse Access
            sym = dlsym(dynammicFileHandle, "uplink_parse_access")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load parse_access function")
            }
            self.parseAccessFunc = unsafeBitCast(sym, to: ParseAccess.self)
            //
            // Access Serialize
            sym = dlsym(dynammicFileHandle, "uplink_access_serialize")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load access_serialize function")
            }
            self.accessSerializeFunc = unsafeBitCast(sym, to: AccessSerialize.self)
            //
            //
            sym = dlsym(dynammicFileHandle, "uplink_access_share")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load access_share function")
            }
            self.accessShareFunc = unsafeBitCast(sym, to: AccessShare.self)
            //
            //
            sym = dlsym(dynammicFileHandle, "uplink_free_string_result")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load free_string_result function")
            }
            self.freeStringResultFunc = unsafeBitCast(sym, to: FreeStringResult.self)
            //
            //
            sym = dlsym(dynammicFileHandle, "uplink_config_request_access_with_passphrase")
            if sym == nil {
                throw storjException(code: 9999, message: "Failed to load config_request_access_with_passphrase function")
            }
            self.configRequestAccessWithPassphraseFunc = unsafeBitCast(sym, to: ConfigRequestAccessWithPassphrase.self)
            //
        } catch {
            throw error
        }
    }
    // Loading project function
    func loadProjectSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        var sym = dlsym(dynammicFileHandle, "uplink_open_project")
        if sym != nil {
            self.openProjectFunc = unsafeBitCast(sym, to: OpenProject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load open_project function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_close_project")
        if sym != nil {
            self.closeProjectFunc = unsafeBitCast(sym, to: CloseProject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load close_project function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_project_result")
        if sym != nil {
            self.freeProjectResultFunc = unsafeBitCast(sym, to: FreeProjectResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_project_result function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_config_open_project")
        if sym != nil {
            self.configOpenProjectFunc = unsafeBitCast(sym, to: ConfigOpenProject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load config_open_project function")
        }
    }
    // Loading bucket functions
    func loadBucketSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        //
        var sym = dlsym(dynammicFileHandle, "uplink_stat_bucket")
        if sym != nil {
            self.statBucketFunc = unsafeBitCast(sym, to: StatBucket.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load stat_bucket function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_create_bucket")
        if sym != nil {
            self.createBucketFunc = unsafeBitCast(sym, to: CreateBucket.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load create_bucket function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_ensure_bucket")
        if sym != nil {
            self.ensureBucketFunc = unsafeBitCast(sym, to: EnsureBucket.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load ensure_bucket function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_delete_bucket")
        if sym != nil {
            self.deleteBucketFunc = unsafeBitCast(sym, to: DeleteBucket.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load delete_bucket function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_bucket")
        if sym != nil {
            self.freeBucketFunc = unsafeBitCast(sym, to: FreeBucket.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_bucket function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_bucket_result")
        if sym != nil {
            self.freeBucketResultFunc = unsafeBitCast(sym, to: FreeBucketResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_bucket_result function")
        }
    }
    // Loading bucket list functions
    func loadBucketListSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        var sym = dlsym(dynammicFileHandle, "uplink_list_buckets")
        if sym != nil {
            self.listBucketsFunc = unsafeBitCast(sym, to: ListBuckets.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load list_buckets function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_bucket_iterator_next")
        if sym != nil {
            self.bucketIteratorNextFunc = unsafeBitCast(sym, to: BucketIteratorNext.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load bucket_iterator_next function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_bucket_iterator_item")
        if sym != nil {
            self.bucketIteratorItemFunc = unsafeBitCast(sym, to: BucketIteratorItem.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load bucket_iterator_item function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_bucket_iterator_err")
        if sym != nil {
            self.bucketIteratorErrorFunc = unsafeBitCast(sym, to: BucketIteratorErr.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load bucket_iterator_err function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_free_bucket_iterator")
        if sym != nil {
            self.freeBucketIteratorFunc = unsafeBitCast(sym, to: FreeBucketIterator.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_bucket_iterator function")
        }
    }
    // Loading object list functions
    func loadObjectSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        //
        var sym = dlsym(dynammicFileHandle, "uplink_stat_object")
        if sym != nil {
            self.statObjectFunc = unsafeBitCast(sym, to: StatObject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load stat_object function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_delete_object")
        if sym != nil {
            self.deleteObjectFunc = unsafeBitCast(sym, to: DeleteObject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load delete_object function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_object_result")
        if sym != nil {
            self.freeObjectResultFunc = unsafeBitCast(sym, to: FreeObjectResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_object_result function")
        }

}
    // Loading Object list function
    func loadObjectListSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        var sym = dlsym(dynammicFileHandle, "uplink_free_object")
        if sym != nil {
            self.freeObjectFunc = unsafeBitCast(sym, to: FreeObject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_object function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_list_objects")
        if sym != nil {
            self.listObjectsFunc = unsafeBitCast(sym, to: ListObjects.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load list_objects function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_object_iterator_next")
        if sym != nil {
            self.objectIteratorNextFunc = unsafeBitCast(sym, to: ObjectIteratorNext.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load object_iterator_next function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_object_iterator_err")
        if sym != nil {
            self.objectIteratorErrorFunc = unsafeBitCast(sym, to: ObjectIteratorErr.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load object_iterator_err function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_object_iterator_item")
        if sym != nil {
            self.objectIteratorItemFunc = unsafeBitCast(sym, to: ObjectIteratorItem.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load object_iterator_item function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_free_object_iterator")
        if sym != nil {
            self.freeObjectIteratorFunc = unsafeBitCast(sym, to: FreeObjectIterator.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_object_iterator function")
        }
    }
    // Loading Upload list function
    func loadUploadSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        var sym = dlsym(dynammicFileHandle, "uplink_upload_object")
        if sym != nil {
            self.uploadObjectFunc = unsafeBitCast(sym, to: UploadObject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_object function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_upload_write")
        if sym != nil {
            self.uploadWriteFunc = unsafeBitCast(sym, to: UploadWrite.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_write function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_upload_commit")
        if sym != nil {
            self.uploadCommitFunc = unsafeBitCast(sym, to: UploadCommit.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_commit function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_upload_abort")
        if sym != nil {
            self.uploadAbortFunc = unsafeBitCast(sym, to: UploadAbort.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_abort function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_upload_set_custom_metadata")
        if sym != nil {
            self.uploadSetCustomMetadataFunc = unsafeBitCast(sym, to: UploadSetCustomMetadata.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_set_custom_metadata function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_write_result")
        if sym != nil {
            self.freeWriteResultFunc = unsafeBitCast(sym, to: FreeWriteResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_write_result function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_upload_result")
        if sym != nil {
            self.freeUploadResultFunc = unsafeBitCast(sym, to: FreeUploadResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_upload_result function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_upload_info")
        if sym != nil {
            self.uploadInfoFunc = unsafeBitCast(sym, to: UploadInfo.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load upload_info function")
        }
    }
    // Loading Download list function
    func loadDownloadSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        var sym = dlsym(dynammicFileHandle, "uplink_download_object")
        if sym != nil {
            self.downloadObjectFunc = unsafeBitCast(sym, to: DownloadObject.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load download_object function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_download_read")
        if sym != nil {
            self.downloadReadFunc = unsafeBitCast(sym, to: DownloadRead.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load download_read function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_download_result")
        if sym != nil {
            self.freeDownloadResultFunc = unsafeBitCast(sym, to: FreeDownloadResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_download_result function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_download_info")
        if sym != nil {
            self.downloadInfoFunc = unsafeBitCast(sym, to: DownloadInfo.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load download_info function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_read_result")
        if sym != nil {
            self.freeReadResultFunc = unsafeBitCast(sym, to: FreeReadResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_read_result function")
        }
        sym = dlsym(dynammicFileHandle, "uplink_close_download")
        if sym != nil {
            self.closeDownloadFunc = unsafeBitCast(sym, to: CloseDownload.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load close_download function")
        }
    }
    // Loading Error list function
    func loadErrorSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        let sym = dlsym(dynammicFileHandle, "uplink_free_error")
        if sym != nil {
            self.freeErrorFunc = unsafeBitCast(sym, to: FreeError.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load free_error function")
        }
    }
    // Loading Encryption functions
    func loadEncryptionSym(dynammicFileHandle: UnsafeMutableRawPointer?) throws {
        //
        var sym = dlsym(dynammicFileHandle, "uplink_access_override_encryption_key")
        if sym != nil {
            self.accessOverrideEncryptionKeyFunc = unsafeBitCast(sym, to: AccessOverrideEncryptionKey.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load uplink_access_override_encryption_key function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_derive_encryption_key")
        if sym != nil {
            self.deriveEncryptionKeyFunc = unsafeBitCast(sym, to:
                DeriveEncryptionKey.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load derive_encryption_key function")
        }
        //
        sym = dlsym(dynammicFileHandle, "uplink_free_encryption_key_result")
        if sym != nil {
            self.freeEncryptionKeyResultFunc = unsafeBitCast(sym, to: FreeEncryptionKeyResult.self)
        } else {
            throw storjException(code: 9999, message: "Failed to load uplink_free_encryption_key_result function")
        }

    }

}
