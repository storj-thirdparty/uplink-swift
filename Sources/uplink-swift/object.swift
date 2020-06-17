import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    //* function frees memory associated with the Object.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<Object>
    //* output: None
     mutating public func free_Object(object:inout UnsafeMutablePointer<Object>)throws {
         self.freeObjectFunc!(object)
    }
        //
      //* function frees memory associated with the ObjectResult.
      //* pre-requisites: None
      //* inputs: ObjectResult
      //* output: None
       mutating public func free_Object_Result(objectResult:inout ObjectResult)throws {
           self.freeObjectResultFunc!(objectResult)
       }
        //* function frees memory associated with the ObjectResult.
        //* pre-requisites: None
        //* inputs: ObjectResult
        //* output: None
         mutating public func free_Object_Iterator(objectIterator:inout UnsafeMutablePointer<ObjectIterator>)throws {
             self.freeObjectIteratorFunc!(objectIterator)
         }
    //
      //* function information about an object at the specific key.
      //* pre-requisites: open_project function has been already called
      //* inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
      //* output: ObjectResult
       mutating public func stat_Object(project:inout UnsafeMutablePointer<Project>, bucketName: NSString, storjObjectName: NSString)throws ->(ObjectResult) {
           let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
           let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
           let objectResult = self.statObjectFunc!(project, ptrBucketName, ptrStorjObjectName)
           return objectResult
       }
        //
        //* function delete object from storj V3
        //* pre-requisites: open_Project function has been already called
        //* inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
        //* output: ObjectResult
         mutating public func delete_Object(project:inout UnsafeMutablePointer<Project>, bucketName: NSString, storjObjectName: NSString)throws ->(ObjectResult) {
             let ptrStorjObjectName = UnsafeMutablePointer<CChar>(mutating: storjObjectName.utf8String)
             let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
             let objectResult = self.deleteObjectFunc!(project, ptrBucketName, ptrStorjObjectName)
             return objectResult
         }
        //* function returns error, if one happened during iteration.
        //* pre-requisites: list_Objects function has been already called
        //* inputs: UnsafeMutablePointer<ObjectIterator>
        //* output: UnsafeMutablePointer<Error>? or nil
         mutating public func object_Iterator_Err(objectIterator:inout UnsafeMutablePointer<ObjectIterator> )throws -> (UnsafeMutablePointer<Error>?) {
             let error = self.objectIteratorErrorFunc!(objectIterator)
             return error
         }
        //* function returns the current object in the iterator.
        //* pre-requisites: list_Objects function has been already called
        //* inputs: UnsafeMutablePointer<ObjectIterator>
        //* output: UnsafeMutablePointer<Object>? or nil
         mutating public func object_Iterator_Item(objectIterator:inout UnsafeMutablePointer<ObjectIterator> )throws -> (UnsafeMutablePointer<Object>?) {
             let object = self.objectIteratorItemFunc!(objectIterator)
             return object
         }
        //* function prepares next Object for reading.
        //* pre-requisites: list_Objects function has been already called
        //* inputs: None
        //* output: Bool
         mutating public func object_Iterator_Next(objectIterator:inout UnsafeMutablePointer<ObjectIterator>)throws -> (Bool) {
             var objectIteratorResult: Bool = false
             objectIteratorResult = self.objectIteratorNextFunc!(objectIterator)
             return (objectIteratorResult)
         }
        //* function lists objects
        //* pre-requisites: open_Project function has been already called
        //* inputs: UnsafeMutablePointer<Project> ,Bucket Name and ListObjectsOptions
        //* output: UnsafeMutablePointer<ObjectIterator>? or nil
        // swiftlint:disable:next line_length
         mutating public func list_Objects(project:inout UnsafeMutablePointer<Project>, storjBucketName: NSString, listObjectsOptions:inout ListObjectsOptions)throws -> (UnsafeMutablePointer<ObjectIterator>?) {
             let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucketName.utf8String)
             let objectIterator = self.listObjectsFunc!(project, ptrToBucketName, &listObjectsOptions)
             return objectIterator
         }
}
