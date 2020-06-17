import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    //* function frees memory associated with the UploadResult.
    //* pre-requisites: None
    //* inputs: UploadResult
    //* output: None
     mutating public func free_Upload_Result(uploadResult:inout UploadResult)throws {
         self.freeUploadResultFunc!(uploadResult)
     }
    //* function frees memory associated with the WriteResult.
    //* pre-requisites: None
    //* inputs: WriteResult
    //* output: None
     mutating public func free_Write_Result(writeResult:inout WriteResult)throws {
         self.freeWriteResultFunc!(writeResult)
     }
    //
    //* function return metadata of uploading object
    //* pre-requisites: upload_Object function has been already called
    //* inputs: UnsafeMutablePointer<Upload>
    //* output: ObjectResult
     mutating public func upload_Info(upload:inout UnsafeMutablePointer<Upload>)throws -> (ObjectResult) {
         let objectResult =  self.uploadInfoFunc!(upload)
         return objectResult
     }
    //
    //* function to set custom metadata on storj V3 object
    //* pre-requisites: upload_Object function has been already called
    //* inputs: UnsafeMutablePointer<Upload> ,CustomMetadata
    //* output: UnsafeMutablePointer<Error>? or nil
     mutating public func upload_Set_Custom_Metadata(upload:inout UnsafeMutablePointer<Upload>, customMetaDataObj: CustomMetadata)throws -> (UnsafeMutablePointer<Error>?) {
         let error = self.uploadSetCustomMetadataFunc!(upload, customMetaDataObj)
         return error
     }
    //
    //* function to abort current upload
    //* pre-requisites: upload_Object function has been already called
    //* inputs: UnsafeMutablePointer<Upload>
    //* output: UnsafeMutablePointer<Error>? or nil
     mutating public func upload_Abort(upload:inout UnsafeMutablePointer<Upload>)throws -> (UnsafeMutablePointer<Error>?) {
         let error = self.uploadAbortFunc!(upload)
         return error
     }
    //
      //* function to commits the uploaded data.
      //* pre-requisites: upload_Object function has been already called
      //* inputs: UnsafeMutablePointer<Upload>
      //* output: UnsafeMutablePointer<Error>? or nil
       mutating public func upload_Commit(upload:inout UnsafeMutablePointer<Upload>)throws -> (UnsafeMutablePointer<Error>?) {
           let error = self.uploadCommitFunc!(upload)
           return (error)
       }
    //
    //* function to upload len(p) bytes from p to the object's data stream.
    //* pre-requisites: upload_Object function has been already called
    //* inputs: UnsafeMutablePointer<Upload> ,Pointer to buffer array , Len of buffer
    //* output: WriteResult
     mutating public func upload_Write(upload:inout UnsafeMutablePointer<Upload>, data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int)throws -> (WriteResult) {
         let writeResult = self.uploadWriteFunc!(upload, data, sizeToWrite)
         return (writeResult)
     }
    //
    //* function to start an upload to the specified key.
    //* pre-requisites: open_Project function has been already called
    //* inputs: UnsafeMutablePointer<Project>, Object name and UnsafeMutablePointer<UploadOptions>
    //* output: UploadResult
    // swiftlint:disable:next line_length
     mutating public func upload_Object(project:inout UnsafeMutablePointer<Project>, storjBucketName: NSString, storjUploadPath: NSString, uploadOptions: UnsafeMutablePointer<UploadOptions>)throws -> (UploadResult) {
         let ptrStorjPath = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
         let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
         let uploadResult = self.uploadObjectFunc!(project, ptrToBucketName, ptrStorjPath, uploadOptions)
         return (uploadResult)
     }
}
