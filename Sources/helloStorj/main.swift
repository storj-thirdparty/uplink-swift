//importing modules
import Foundation
import uplink_swift
import libuplink
//
// Storj V3 API key
var storjApiKey: NSString = "change-me-to-desired-api-key"
// Storj V3 satellite address
var storjSatellite: NSString = "us-central-1.tardigrade.io:7777"
// Storj V3 encryption passphrase
var storjEncryption: NSString = "change-me-to-desired-encryptionphassphrase"
// Storj bucket name
var storjBucket: NSString = "change-me-to-desired-bucket-name"
// Upload path within the bucket, where file will be uploaded.
var storjUploadPath: NSString = "path/filename.txt"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath: NSString = "path/filename"
// Full file name, including path, of the local system, to be uploaded to Storj bucket.
var localFullFileNameToUpload: NSString = "change-me-to-fullfilepath-on-local-system"
// Local full path, where the Storj object is to be stored after download.
var localFullFileLocationToStore: NSString = "change-me-to-desired-fullfile-name"
//
// for convert unix time
func unixTimeConvert(unixTime: Int64) -> (String) {
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixTime))
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
    let dateString = dayTimePeriodFormatter.string(from: date as Date)
    return dateString
}
//
//Storj("change-me-to-dylib-location") if not provided then default path will be uplink-swift/Sources/libUplink/include
//for example Storj("locationWhereStorjSwiftIsDownload/Sources/libUplink/include/libuplinkc.dylib")
do {
    // swiftlint:disable line_length
    var storjSwift = try Storj("")
    print("Getting Accessig using :\nSatellite address : \(storjSatellite)\nAPI key : \(storjApiKey)\nEncryption phassphrase : \(storjEncryption)")
    var accessResult = try storjSwift.request_Access_With_Passphrase(satellite: storjSatellite, apiKey: storjApiKey, encryption: storjEncryption)
    //
    //Checking Whether Error or Access is return.
    if accessResult.access != nil {
        print("Access granted !!")
        print("Opening project on storj V3 network.....")
        //
        var projectResult = try storjSwift.open_Project(access: &accessResult.access)
        if projectResult.project != nil {
            print("\nGetting info about bucket : ", storjBucket)
            var bucketResult = try storjSwift.stat_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if bucketResult.bucket != nil {
                print("Bucket information :\nBucket created : ", unixTimeConvert(unixTime: bucketResult.bucket.pointee.created))
                print("Bucket name : ", String(validatingUTF8: bucketResult.bucket.pointee.name!)!)
            } else if bucketResult.error != nil {
                print("Failed to get information about bucket \n Error code : ", bucketResult.error.pointee.code, "\n Error message : ", String(validatingUTF8: bucketResult.error.pointee.message!)!)
            }
            try storjSwift.free_Bucket_Result(bucketResult: &bucketResult)
            //
            //Creating bucket on storj V3 networks
            print("\nCreating bucket : ", storjBucket)
            var createBucketResultObj = try  storjSwift.create_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if createBucketResultObj.bucket != nil {
               print("\nBucket created !!")
                print("Bucket name : ", String(validatingUTF8: createBucketResultObj.bucket.pointee.name!)!)
                print("Bucket created : ", unixTimeConvert(unixTime: createBucketResultObj.bucket.pointee.created))
            } else {
                print("\nFailed to create bucket \n Error code : ", createBucketResultObj.error.pointee.code)
                print("\nError message : ", String(validatingUTF8: createBucketResultObj.error.pointee.message!)!)
            }
            //free bucket result
            try storjSwift.free_Bucket_Result(bucketResult: &createBucketResultObj)
            //
            //Ensuring bucket exits on storj V3 network
            print("\nGetting info of created bucket")
            var ensureBucketResult = try  storjSwift.ensure_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if ensureBucketResult.bucket != nil {
                print("Bucket name : ", String(validatingUTF8: ensureBucketResult.bucket.pointee.name!)!)
                print("Bucket created : ", unixTimeConvert(unixTime: ensureBucketResult.bucket.pointee.created))
            } else {
                print("Failed to get information of bucket \n Error code : ", ensureBucketResult.error.pointee.code)
                print("Error message : ", String(validatingUTF8: ensureBucketResult.error.pointee.message!)!)
            }
            try storjSwift.free_Bucket_Result(bucketResult: &ensureBucketResult)
            //
            //Listing Bucket
            print("\n\nListing buckets...")
            listBucket(storjSwift: &storjSwift, project: &projectResult.project)
            print("\n\nUploading object...")
            //
            //Uploading file on storj V3 network
            uploadObject(storjSwift: &storjSwift, project: &projectResult.project, bucketName: storjBucket, localFullFileNameToUpload: localFullFileNameToUpload, storjUploadPath: storjUploadPath)
            print("\n\nDownloading object...")
            //
            //downloading file from storj v3 object
            // swiftlint:disable:next line_length
            downloadObject(storjSwift: &storjSwift, project: &projectResult.project, bucketName: storjBucket, localFullFileLocationToStore: localFullFileLocationToStore, storjDownloadPath: storjDownloadPath)
            //
            //
            print("\n\nListing objects")
            listObjects(storjSwift: &storjSwift, project: &projectResult.project, bucketName: storjBucket)
            //
            //
            print("Creating share access")
            var permission = Permission()
            permission.allow_delete = true
            permission.allow_upload = true
            //
            var sharePrefix = SharePrefix()
            let ptrToBucketName = UnsafeMutablePointer<CChar>(mutating: storjBucket.utf8String)
            let objectPrefix: NSString = "change-me-to-desired-prefix/path"
            let prefix = UnsafeMutablePointer<CChar>(mutating: objectPrefix.utf8String)
            //
            sharePrefix.bucket = ptrToBucketName
            sharePrefix.prefix = prefix
            //
            // swiftlint:disable line_length
            var sharePrefixArray = [sharePrefix]
            var ptrTosharePrefix = UnsafeMutablePointer<SharePrefix>.allocate(capacity: sharePrefixArray.count)
            ptrTosharePrefix.initialize(from: &sharePrefixArray, count: sharePrefixArray.count)
            //
            var sharedAccess = try storjSwift.access_Share(access: &accessResult.access, permission: &permission, prefix: &ptrTosharePrefix, prefixCount: sharePrefixArray.count)
            //
            if sharedAccess.access != nil {
                //
                print("\nShared access created !!")
                var stringResult = try storjSwift.access_Serialize(access: &accessResult.access.pointee)
                if stringResult.error != nil {
                    print("Error while serializing shared access")
                    print("Error code : ", stringResult.error.pointee.code, "Error message : ", String(validatingUTF8: stringResult.error.pointee.message!)!)
                } else {
                    let stringKey: NSString = String(validatingUTF8: stringResult.string)! as NSString
                    print("\nShared string : ", stringKey)
                    print("\nParsing access")
                    //
                    var shareAccessResult = try  storjSwift.parse_Access(stringKey: stringKey)
                    if shareAccessResult.access != nil {
                        //
                        print("Opening project using shared access")
                        var sharedProjectResult = try storjSwift.open_Project(access: &shareAccessResult.access)
                        //
                        if sharedProjectResult.project != nil {
                            //Deleting object using project opended with access share
                            var deleteObjectResult = try storjSwift.delete_Object(project: &sharedProjectResult.project, bucketName: storjBucket, storjObjectName: storjUploadPath)
                            //
                            if deleteObjectResult.object != nil {
                                print("Object deleted !!")
                                print("Object name : ", String(validatingUTF8: deleteObjectResult.object.pointee.key!)!)
                            } else if deleteObjectResult.error != nil {
                                print("Failed to delete object \n Error code : ", deleteObjectResult.error.pointee.code)
                                print("Error message : ", String(validatingUTF8: deleteObjectResult.error.pointee.message!)!)
                            }
                            //
                            //Free Object Result
                            try storjSwift.free_Object_Result(objectResult: &deleteObjectResult)
                            print("Closing project opended with shared access")
                            //Closing Project
                            var error = try storjSwift.close_Project(project: &sharedProjectResult.project)
                            if error != nil {
                                print("Failed to close project")
                                try storjSwift.free_Error(error: &(error)!)
                            } else {
                                print("Project closed")
                            }
                        } else {
                            print("Failed to open project \n Error Code : ", sharedProjectResult.error.pointee.code)
                            print("Error Message : ", String( validatingUTF8: sharedProjectResult.error.pointee.message!)!)
                        }
                        //Free ProjectResult
                        try storjSwift.free_Project_Result(projectResult: &sharedProjectResult)
                    } else {
                        print("Shared Access \n Error Code : ", shareAccessResult.error.pointee.code)
                        print("\n Error Message : ", String(validatingUTF8: shareAccessResult.error.pointee.message!)!)
                    }
                    //Free Access Result
                    try storjSwift.free_Access_Result(accessResult: &shareAccessResult)
                }
                //Free String Result
                try storjSwift.free_String_Result(stringResult: &stringResult)
            } else {
                print("Error received while sharing access")
                print("\nError code : ", sharedAccess.error.pointee.code)
                print("Error message : ", String(validatingUTF8: sharedAccess.error.pointee.message!)!)
            }
            try storjSwift.free_Access_Result(accessResult: &sharedAccess)
            print("Deleting object on storj V3 network...")
            //
            //Deleting Object
            var deleteObjectResult = try storjSwift.delete_Object(project: &projectResult.project, bucketName: storjBucket, storjObjectName: storjUploadPath)
            if deleteObjectResult.object != nil {
                print("Object deleted !!")
                print("Object name : ", String(validatingUTF8: deleteObjectResult.object.pointee.key!)!)
            } else if deleteObjectResult.error != nil {
                print("Failed to delete object \n Error code : ", deleteObjectResult.error.pointee.code)
                print("\n Error message : ", String(validatingUTF8: deleteObjectResult.error.pointee.message!)!)
            }
            //Free Object Result
            try storjSwift.free_Object_Result(objectResult: &deleteObjectResult)
            //
            print("Deleting Bucket...")
            //Deleting empty bucket on storj
            var deleteBucketResult = try storjSwift.delete_Bucket(project: &projectResult.project, bucketName: storjBucket)
            if deleteBucketResult.bucket != nil {
                print("Bucket deleted!!")
                print("Bucket name : ", String(validatingUTF8: deleteBucketResult.bucket.pointee.name!)!)
                print("Bucket created : ", unixTimeConvert(unixTime: deleteBucketResult.bucket.pointee.created))
            } else if deleteBucketResult.error != nil {
                print("Failed to delete bucket \n Error code : ", deleteBucketResult.error.pointee.code)
                print("\n Error message : ", String(validatingUTF8: deleteBucketResult.error.pointee.message!)!)
            }
            //Free BucketResult
            try storjSwift.free_Bucket_Result(bucketResult: &deleteBucketResult)
            //Closing opened project
            var error = try storjSwift.close_Project(project: &projectResult.project)
            if error != nil {
                print("Failed to close project")
                try storjSwift.free_Error(error: &(error)!)
            } else {
                print("Project closed !! ")
            }
        } else {
            //Displaying Error
            print("Failed to get access using API Key \n Error code : ", projectResult.error.pointee.code)
            print("Error message : ", String(validatingUTF8: projectResult.error.pointee.message!)!)
        }
        //Freeing ProjectResult
        try storjSwift.free_Project_Result(projectResult: &projectResult)
    } else {
        //Displaying Error
        print("Failed to get access using API Key \n Error code :  \(accessResult.error.pointee.code)\n Error message : \(String(validatingUTF8: accessResult.error.pointee.message!)!)")
    }
    //Free AccessResult
    try storjSwift.free_Access_Result(accessResult: &accessResult)
} catch {
    print("Error : \(error)")
}
