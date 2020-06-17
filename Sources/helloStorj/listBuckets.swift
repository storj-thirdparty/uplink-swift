import Foundation
import uplink_swift
import libuplink

//Function for listing Buckets
// swiftlint:disable line_length
func listBucket(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>) {
    do {
        var listBucketsOptionsObj = ListBucketsOptions()
        var bucketIterator = try storjSwift.list_Buckets(project: &project, listBucketsOptionsObj: &listBucketsOptionsObj)
        if bucketIterator != nil {
            while try storjSwift.bucket_Iterator_Next(bucketIterator: &(bucketIterator)!) {
                var bucket = try storjSwift.bucket_Iterator_Item(bucketIterator: &(bucketIterator)!)
                if bucket != nil {
                    let blankString: NSString = ""
                    let ptrblankString = UnsafeMutablePointer<CChar>(mutating: blankString.utf8String)
                    print("Bucket name : ", String(validatingUTF8: (bucket?.pointee.name ?? ptrblankString)!)!)
                    print("Bucket created : ", unixTimeConvert(unixTime: bucket?.pointee.created ?? 0))
                }
                if bucket != nil {
                    try storjSwift.free_Bucket(bucket: &(bucket)!)
                }
            }
            //
            var(error) = try  storjSwift.bucket_Iterator_Err(bucketIterator: &(bucketIterator)!)
            if error != nil {
                print("Error while listing bucket...")
                print("Error code : ", error?.pointee.code ?? 0, "\n Error message : ", String(validatingUTF8: (error?.pointee.message)!)!)
                try storjSwift.free_Error(error: &(error)!)
            } else {
                print("Bucket listed successfully !!")
            }
        }
        try storjSwift.free_Bucket_Iterator(bucketIterator: &(bucketIterator)!)
    } catch {
        print("Error while listing bucket")
        print(error)
    }
}
