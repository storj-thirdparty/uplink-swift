import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
    //
    //* function frees memory associated with the BucketResult.
    //* pre-requisites: None
    //* inputs: BucketResult
    //* output: None
     mutating public func free_Bucket_Result(bucketResult:inout BucketResult)throws {
         self.freeBucketResultFunc!(bucketResult)
    }
    //* function frees memory associated with the Bucket.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<Bucket>
    //* output: Uplink and error (string)
     mutating public func free_Bucket(bucket:inout UnsafeMutablePointer<Bucket>)throws {
         self.freeBucketFunc!(bucket)
     }
    //* function frees memory associated with the BucketIterator.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<Access>,Permission, UnsafeMutablePointer<SharePrefix>,Size of Share Prefix
    //* output: None
     mutating public func free_Bucket_Iterator(bucketIterator:inout UnsafeMutablePointer<BucketIterator>)throws {
         self.freeBucketIteratorFunc!(bucketIterator)
     }
    //
    //* function bucket_iterator_err returns error, if one happened during iteration.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<BucketIterator>
    //* output: UnsafeMutablePointer<Error>? or nil
     mutating public func bucket_Iterator_Err(bucketIterator:inout UnsafeMutablePointer<BucketIterator> )throws -> (UnsafeMutablePointer<Error>?) {
         let error = self.bucketIteratorErrorFunc!(bucketIterator)
         return error
     }
    //
    //* function to returns the current bucket in the iterator.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<BucketIterator>
    //* output: UnsafeMutablePointer<Bucket>? or nil
     mutating public func bucket_Iterator_Item(bucketIterator:inout UnsafeMutablePointer<BucketIterator> )throws -> (UnsafeMutablePointer<Bucket>?) {
        let bucket = self.bucketIteratorItemFunc!(bucketIterator)
        return bucket
     }
    //
    //* function prepares next Bucket for reading.
    //* pre-requisites: None
    //* inputs: UnsafeMutablePointer<BucketIterator>
    //* output: Bool
     mutating public func bucket_Iterator_Next(bucketIterator:inout UnsafeMutablePointer<BucketIterator>)throws ->(Bool) {
         var bucketIteratorResult: Bool = false
         bucketIteratorResult = self.bucketIteratorNextFunc!(bucketIterator)
         return (bucketIteratorResult)
     }
    //
      //* function to lists buckets
      //* pre-requisites: open_Project function has been already called
      //* inputs: UnsafeMutablePointer<Project> and List Bucket Options
      //* output: UnsafeMutablePointer<BucketIterator>? or nil
       mutating public func list_Buckets(project:inout UnsafeMutablePointer<Project>, listBucketsOptionsObj:inout ListBucketsOptions)throws -> (UnsafeMutablePointer<BucketIterator>?) {
           let bucketIterator = self.listBucketsFunc!(project, &listBucketsOptionsObj)
           return bucketIterator
       }
        //
        //* function to delete empty bucket on storj V3
        //* pre-requisites: open_Project function has been already called
        //* inputs: UnsafeMutablePointer<Project> and Bucket Name
        //* output: BucketResult
         mutating public func delete_Bucket(project:inout UnsafeMutablePointer<Project>, bucketName: NSString)throws -> (BucketResult) {
             let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
             let bucketResult = self.deleteBucketFunc!(project, ptrBucketName)
             return bucketResult
         }
    //* function to creates a new bucket and ignores the error when it already exists
    //* pre-requisites: open_Project function has been already called
    //* inputs: UnsafeMutablePointer<Project> and Bucket Name
    //* output: BucketResult
     mutating public func ensure_Bucket(project:inout UnsafeMutablePointer<Project>, bucketName: NSString)throws -> (BucketResult) {
         let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
         let bucketResult = self.ensureBucketFunc!(project, ptrBucketName)
         return (bucketResult)
     }
    //
    //* function to create bucket on storj V3
    //* pre-requisites: open_Project function has been already called
    //* inputs: UnsafeMutablePointer<Project> and Bucket Name
    //* output: BucketResult
     mutating public func create_Bucket(project:inout UnsafeMutablePointer<Project>, bucketName: NSString)throws -> (BucketResult) {
          let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
          let bucketResult = self.createBucketFunc!(project, ptrBucketName)
          return (bucketResult)
      }
    //
    //* function returns information about a bucket.
    //* pre-requisites: None
    //* inputs: Config,Satellite Address, API Key and Encryptionphassphrase
    //* output: BucketResult
     mutating public func stat_Bucket(project:inout UnsafeMutablePointer<Project>, bucketName: NSString)throws ->(BucketResult) {
         let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: bucketName.utf8String)
         let bucketResult = self.statBucketFunc!(project, ptrBucketName)
         return bucketResult
     }
}
