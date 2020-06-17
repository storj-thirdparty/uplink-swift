import Foundation
import libuplink
//for throwing error
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
//Storj Swift
// swiftlint:disable line_length
public struct Storj {
    //
    var dynammicFileHandle: UnsafeMutableRawPointer?
    var dylibNotFound: String = "Failed to find .dylib file at : "
    var failToOpenDylib: String = "Failed to open .dylib file"
    var failToFoundFunction: String = "Symbol not found in .dylib"
    //
    var parseAccessFunc: ParseAccess?, requestAccessWithPassphraseFunc: RequestAccessWithPassphrase?, accessSerializeFunc: AccessSerialize?, accessShareFunc: AccessShare?
    //
    var freeStringResultFunc: FreeStringResult?, freeAccessResultFunc: FreeAccessResult?, statBucketFunc: StatBucket?, createBucketFunc: CreateBucket?
    //
    var ensureBucketFunc: EnsureBucket?, deleteBucketFunc: DeleteBucket?, listBucketsFunc: ListBuckets?
    //
    var bucketIteratorNextFunc: BucketIteratorNext?, bucketIteratorErrorFunc: BucketIteratorErr?, bucketIteratorItemFunc: BucketIteratorItem?
    //
    var freeBucketIteratorFunc: FreeBucketIterator?, configRequestAccessWithPassphraseFunc: ConfigRequestAccessWithPassphrase?, configOpenProjectFunc: ConfigOpenProject?
    //
    var downloadObjectFunc: DownloadObject?, downloadReadFunc: DownloadRead?, freeDownloadResultFunc: FreeDownloadResult?, downloadInfoFunc: DownloadInfo?
    //
    var uploadInfoFunc: UploadInfo?, freeReadResultFunc: FreeReadResult?, closeDownloadFunc: CloseDownload?, freeBucketResultFunc: FreeBucketResult?, freeErrorFunc: FreeError?
    //
    var statObjectFunc: StatObject?, deleteObjectFunc: DeleteObject?, freeObjectResultFunc: FreeObjectResult?, freeObjectFunc: FreeObject?, listObjectsFunc: ListObjects?
    //
    var objectIteratorNextFunc: ObjectIteratorNext?, objectIteratorErrorFunc: ObjectIteratorErr?, objectIteratorItemFunc: ObjectIteratorItem?
    //
    var freeObjectIteratorFunc: FreeObjectIterator?, openProjectFunc: OpenProject?, closeProjectFunc: CloseProject?
    //
    var freeProjectResultFunc: FreeProjectResult?, uploadObjectFunc: UploadObject?, uploadWriteFunc: UploadWrite?, uploadCommitFunc: UploadCommit?
    //
    var uploadAbortFunc: UploadAbort?, uploadSetCustomMetadataFunc: UploadSetCustomMetadata?
    //
    var freeWriteResultFunc: FreeWriteResult?, freeUploadResultFunc: FreeUploadResult?, freeBucketFunc: FreeBucket?

    public var dynamicFileLocation: String = ""
    public init(_ userLiblocation: String) throws {
        if !userLiblocation.isEmpty {
            self.dynamicFileLocation = userLiblocation
        } else {
            let storjswiftPath = URL(fileURLWithPath: #file)
            var storjSwiftPathString = storjswiftPath.path
            if storjSwiftPathString.contains("uplink-swift/") {
                storjSwiftPathString = storjSwiftPathString.components(separatedBy: "Sources/uplink-swift/")[0]
                storjSwiftPathString += "Sources/libuplink/include/libuplinkc.dylib"
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: storjSwiftPathString) {
                    self.dynamicFileLocation = storjSwiftPathString
                    }
                }
        }
        //Checking whether file exits or not
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: self.dynamicFileLocation) {
            self.dynammicFileHandle = dlopen(self.dynamicFileLocation, RTLD_LOCAL|RTLD_NOW)
            if self.dynammicFileHandle == nil {
                throw self.failToOpenDylib
            } else {
                do {
                    try self.loadErrorSym()
                    try self.loadUploadSym()
                    try self.loadBucketSym()
                    try self.loadDownloadSym()
                    try self.loadBucketListSym()
                    try self.loadObjectListSym()
                    try self.loadAccessSym()
                    try self.loadProjectSym()
                    try self.loadObjectSym()
                } catch {
                    throw error
                }
            }
        } else {
            throw self.dylibNotFound+self.dynamicFileLocation
        }
    }
}
