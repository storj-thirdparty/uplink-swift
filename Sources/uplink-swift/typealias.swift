import Foundation
import libuplink

//swiftlint:disable line_length
extension Storj {
    //Creating typesalias of all the functions
    typealias ParseAccess = @convention(c)(UnsafeMutablePointer<Int8>?) -> (UplinkAccessResult)
    //
    typealias RequestAccessWithPassphrase = @convention(c)(UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (UplinkAccessResult)
    //
    typealias AccessSerialize = @convention(c)(UnsafeMutablePointer<UplinkAccess>?) -> UplinkStringResult
    //
    typealias AccessShare = @convention(c)(UnsafeMutablePointer<UplinkAccess>, UplinkPermission, UnsafeMutablePointer<UplinkSharePrefix>, GoInt) -> UplinkAccessResult
    //
    typealias FreeStringResult = @convention(c)(UplinkStringResult) -> Void
    //
    typealias FreeAccessResult = @convention(c)(UplinkAccessResult) -> Void
    //
    typealias StatBucket = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?) -> (UplinkBucketResult)
    //
    typealias CreateBucket = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?) -> (UplinkBucketResult)
    //
    typealias EnsureBucket = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?) -> (UplinkBucketResult)
    //
    typealias DeleteBucket = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?) -> (UplinkBucketResult)
    //
    typealias ListBuckets = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<UplinkListBucketsOptions>) ->  (UnsafeMutablePointer<UplinkBucketIterator>?)
    //
    typealias BucketIteratorNext = @convention(c)(UnsafeMutablePointer<UplinkBucketIterator>) -> (Bool)
    //
    typealias BucketIteratorErr = @convention(c)(UnsafeMutablePointer<UplinkBucketIterator>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias BucketIteratorItem = @convention(c)(UnsafeMutablePointer<UplinkBucketIterator>) -> (UnsafeMutablePointer<UplinkBucket>?)
    //
    typealias FreeBucketIterator = @convention(c)(UnsafeMutablePointer<UplinkBucketIterator>) -> Void
    //
    typealias ConfigRequestAccessWithPassphrase = @convention(c)(UplinkConfig, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (UplinkAccessResult)
    //
    typealias ConfigOpenProject = @convention(c)(UplinkConfig, UnsafeMutablePointer<UplinkAccess>?) -> (UplinkProjectResult)
    //
    typealias DownloadObject = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<UplinkDownloadOptions>) -> (UplinkDownloadResult)
    //
    typealias DownloadRead = @convention(c)(UnsafeMutablePointer<UplinkDownload>, UnsafeMutableRawPointer?, Int) -> (UplinkReadResult)
    //
    typealias DownloadInfo = @convention(c)(UnsafeMutablePointer<UplinkDownload>) -> (UplinkObjectResult)
    //
    typealias UploadInfo = @convention(c)(UnsafeMutablePointer<UplinkUpload>) -> (UplinkObjectResult)
    //
    typealias FreeReadResult = @convention(c)(UplinkReadResult) -> Void
    //
    typealias CloseDownload  = @convention(c)(UnsafeMutablePointer<UplinkDownload>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias FreeDownloadResult = @convention(c)(UplinkDownloadResult) -> Void
    //
    typealias FreeBucketResult = @convention(c)(UplinkBucketResult) -> Void
    //
    typealias FreeError = @convention(c)(UnsafeMutablePointer<UplinkError>?) -> Void
    //
    typealias StatObject = @convention(c)(UnsafeMutablePointer<UplinkProject>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (UplinkObjectResult)
    //
    typealias DeleteObject = @convention(c)(UnsafeMutablePointer<UplinkProject>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (UplinkObjectResult)
    //
    typealias FreeObjectResult = @convention(c)(UplinkObjectResult) -> Void
    //
    typealias FreeObject = @convention(c)(UnsafeMutablePointer<UplinkObject>) -> Void
    //
    typealias ListObjects = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<UplinkListObjectsOptions>) -> (UnsafeMutablePointer<UplinkObjectIterator>?)
    //
    typealias ObjectIteratorNext = @convention(c)(UnsafeMutablePointer<UplinkObjectIterator>) -> (Bool)
    //
    typealias ObjectIteratorErr = @convention(c)(UnsafeMutablePointer<UplinkObjectIterator>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias ObjectIteratorItem = @convention(c)(UnsafeMutablePointer<UplinkObjectIterator>) -> (UnsafeMutablePointer<UplinkObject>?)
    //
    typealias FreeObjectIterator = @convention(c)(UnsafeMutablePointer<UplinkObjectIterator>) -> Void
    //
    typealias OpenProject = @convention(c)(UnsafeMutablePointer<UplinkAccess>) -> (UplinkProjectResult)
    //
    typealias CloseProject = @convention(c)(UnsafeMutablePointer<UplinkProject>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias FreeProjectResult = @convention(c)(UplinkProjectResult) -> Void
    //
    typealias UploadObject = @convention(c)(UnsafeMutablePointer<UplinkProject>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<UplinkUploadOptions>) -> (UplinkUploadResult)
    //
    typealias UploadWrite = @convention(c)(UnsafeMutablePointer<UplinkUpload>, UnsafeMutableRawPointer?, Int) -> (UplinkWriteResult)
    //
    typealias UploadCommit = @convention(c)(UnsafeMutablePointer<UplinkUpload>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias UploadAbort = @convention(c)(UnsafeMutablePointer<UplinkUpload>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias UploadSetCustomMetadata = @convention(c)(UnsafeMutablePointer<UplinkUpload>, UplinkCustomMetadata) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias FreeWriteResult = @convention(c)(UplinkWriteResult) -> Void
    //
    typealias FreeUploadResult = @convention(c)(UplinkUploadResult) -> Void
    //
    typealias FreeBucket = @convention(c)(UnsafeMutablePointer<UplinkBucket>) -> Void
    //
    typealias AccessOverrideEncryptionKey = @convention(c)(UnsafeMutablePointer<UplinkAccess>, UnsafePointer<uplink_const_char>, UnsafePointer<uplink_const_char>, UnsafeMutablePointer<UplinkEncryptionKey>) -> (UnsafeMutablePointer<UplinkError>?)
    //
    typealias DeriveEncryptionKey = @convention(c)(UnsafePointer<uplink_const_char>, UnsafeMutableRawPointer, Int) -> (UplinkEncryptionKeyResult)
    //
    typealias FreeEncryptionKeyResult = @convention(c)(UplinkEncryptionKeyResult) -> Void
    //
}
