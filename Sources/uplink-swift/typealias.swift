import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    //Creating typesalias of all the functions
    typealias ParseAccess = @convention(c)(UnsafeMutablePointer<Int8>?) -> (AccessResult)
    //
    typealias RequestAccessWithPassphrase = @convention(c)(UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (AccessResult)
    //
    typealias AccessSerialize = @convention(c)(UnsafeMutablePointer<Access>?) -> StringResult
    //
    typealias AccessShare = @convention(c)(UnsafeMutablePointer<Access>, Permission, UnsafeMutablePointer<SharePrefix>, GoInt) -> AccessResult
    //
    typealias FreeStringResult = @convention(c)(StringResult) -> Void
    //
    typealias FreeAccessResult = @convention(c)(AccessResult) -> Void
    //
    typealias StatBucket = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias CreateBucket = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias EnsureBucket = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias DeleteBucket = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?) -> (BucketResult)
    //
    typealias ListBuckets = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<ListBucketsOptions>) ->  (UnsafeMutablePointer<BucketIterator>)
    //
    typealias BucketIteratorNext = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (Bool)
    //
    typealias BucketIteratorErr = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (UnsafeMutablePointer<Error>)
    //
    typealias BucketIteratorItem = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> (UnsafeMutablePointer<Bucket>)
    //
    typealias FreeBucketIterator = @convention(c)(UnsafeMutablePointer<BucketIterator>) -> Void
    //
    typealias ConfigRequestAccessWithPassphrase = @convention(c)(Config, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (AccessResult)
    //
    typealias ConfigOpenProject = @convention(c)(Config, UnsafeMutablePointer<Access>?) -> (ProjectResult)
    //
    typealias DownloadObject = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<DownloadOptions>) -> (DownloadResult)
    //
    typealias DownloadRead = @convention(c)(UnsafeMutablePointer<Download>, UnsafeMutableRawPointer?, Int) -> (ReadResult)
    //
    typealias DownloadInfo = @convention(c)(UnsafeMutablePointer<Download>) -> (ObjectResult)
    //
    typealias UploadInfo = @convention(c)(UnsafeMutablePointer<Upload>) -> (ObjectResult)
    //
    typealias FreeReadResult = @convention(c)(ReadResult) -> Void
    //
    typealias CloseDownload  = @convention(c)(UnsafeMutablePointer<Download>) -> (UnsafeMutablePointer<Error>)
    //
    typealias FreeDownloadResult = @convention(c)(DownloadResult) -> Void
    //
    typealias FreeBucketResult = @convention(c)(BucketResult) -> Void
    //
    typealias FreeError = @convention(c)(UnsafeMutablePointer<Error>) -> Void
    //
    typealias StatObject = @convention(c)(UnsafeMutablePointer<Project>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (ObjectResult)
    //
    typealias DeleteObject = @convention(c)(UnsafeMutablePointer<Project>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?) -> (ObjectResult)
    //
    typealias FreeObjectResult = @convention(c)(ObjectResult) -> Void
    //
    typealias FreeObject = @convention(c)(UnsafeMutablePointer<Object>) -> Void
    //
    typealias ListObjects = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<ListObjectsOptions>) -> (UnsafeMutablePointer<ObjectIterator>)
    //
    typealias ObjectIteratorNext = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (Bool)
    //
    typealias ObjectIteratorErr = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (UnsafeMutablePointer<Error>)
    //
    typealias ObjectIteratorItem = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> (UnsafeMutablePointer<Object>)
    //
    typealias FreeObjectIterator = @convention(c)(UnsafeMutablePointer<ObjectIterator>) -> Void
    //
    typealias OpenProject = @convention(c)(UnsafeMutablePointer<Access>) -> (ProjectResult)
    //
    typealias CloseProject = @convention(c)(UnsafeMutablePointer<Project>) -> (UnsafeMutablePointer<Error>)
    //
    typealias FreeProjectResult = @convention(c)(ProjectResult) -> Void
    //
    typealias UploadObject = @convention(c)(UnsafeMutablePointer<Project>, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<Int8>?, UnsafeMutablePointer<UploadOptions>) -> (UploadResult)
    //
    typealias UploadWrite = @convention(c)(UnsafeMutablePointer<Upload>, UnsafeMutableRawPointer?, Int) -> (WriteResult)
    //
    typealias UploadCommit = @convention(c)(UnsafeMutablePointer<Upload>) -> (UnsafeMutablePointer<Error>)
    //
    typealias UploadAbort = @convention(c)(UnsafeMutablePointer<Upload>) -> (UnsafeMutablePointer<Error>)
    //
    typealias UploadSetCustomMetadata = @convention(c)(UnsafeMutablePointer<Upload>, CustomMetadata) -> (UnsafeMutablePointer<Error>)
    //
    typealias FreeWriteResult = @convention(c)(WriteResult) -> Void
    //
    typealias FreeUploadResult = @convention(c)(UploadResult) -> Void
    //
    typealias FreeBucket = @convention(c)(UnsafeMutablePointer<Bucket>) -> Void
}
