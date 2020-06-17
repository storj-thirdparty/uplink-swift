import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    //* function frees memory associated with the DownloadResult.
    //* pre-requisites: None
    //* inputs: DownloadResult
    //* output: None
     mutating public func free_Download_Result(downloadResult:inout DownloadResult)throws {
         self.freeDownloadResultFunc!(downloadResult)
     }
    //
    //* function frees memory associated with the ReadResult.
    //* pre-requisites: None
    //* inputs: ReadResult
    //* output: None
     mutating public func free_Read_Result(readResult:inout ReadResult)throws {
         self.freeReadResultFunc!(readResult)
     }
    //
    //* function returns metadata of downloading object
    //* pre-requisites: download_Object function has been already called
    //* inputs: UnsafeMutablePointer<Download>
    //* output: ObjectResult
     mutating public func download_Info(download:inout UnsafeMutablePointer<Download>)throws -> (ObjectResult) {
         let objectResult =  self.downloadInfoFunc!(download)
         return objectResult
     }
    //
    //* function closes download
    //* pre-requisites: download_Object function has been already called
    //* inputs: UnsafeMutablePointer<Download>
    //* output: UnsafeMutablePointer<Error>? or nil
     mutating public func close_Download(download:inout UnsafeMutablePointer<Download>)throws -> (UnsafeMutablePointer<Error>?) {
         let error =  self.closeDownloadFunc!(download)
         return error
     }
    //
    //* function reads byte stream from storj V3
    //* pre-requisites: download_Object function has been already called
    //* inputs: UnsafeMutablePointer<Download> ,Pointer to array buffer, Size of Buffer
    //* output: ReadResult
     mutating public func download_Read(download:inout UnsafeMutablePointer<Download>, data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int)throws -> (ReadResult) {
         let readResult = self.downloadReadFunc!(download, data, sizeToWrite)
         return readResult
     }
    //
    //* function for dowloading object
    //* pre-requisites: open_Project function has been already called
    //* inputs: UnsafeMutablePointer<Project> ,Object Name on storj V3 and UnsafeMutablePointer<DownloadOptions>
    //* output: DownloadResult
    // swiftlint:disable:next line_length
     mutating public func download_Object(project:inout UnsafeMutablePointer<Project>, storjBucketName: NSString, storjObjectName: NSString, downloadOptions: UnsafeMutablePointer<DownloadOptions>)throws -> (DownloadResult) {
         let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
         let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
         let downloadResult = self.downloadObjectFunc!(project, ptrToBucketName, ptrStorjPath, downloadOptions)
         return (downloadResult)
     }
}
