import Foundation
import uplink_swift
//
//swiftlint:disable line_length
// Storj V3 API key
var storjApiKey: String = "change-me-to-desired-api-key"
// Storj V3 satellite address
var storjSatellite: String = "us-central-1.tardigrade.io:7777"
// Storj V3 encryption passphrase
var storjEncryption: String = "change-me-to-desired-encryptionphassphrase"
// Storj bucket name
var storjBucket: String = "change-me-to-desired-bucket-name"
// Upload path within the bucket, where file will be uploaded.
var storjUploadPath: String = "path/filename.txt"
// Upload path within the bucket, where file will be uploaded via overridden serialized access key
var storjUploadPath2: String = "path/filename2.txt"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath: String = "path/filename.txt"
// Full file name, including path, of the local system, to be uploaded to Storj bucket.
var localFullFileNameToUpload: String = "change-me-to-fullfilepath-on-local-system"
// Local full path, where the Storj object is to be stored after download.
var localFullFileLocationToStore: String = "change-me-to-desired-fullfile-name"
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
do {
    //
    let uplink = try Storj.uplink()
    //
    print("Getting Access using :\nSatellite address : \(storjSatellite)\nAPI key : \(storjApiKey)\nEncryption phassphrase : \(storjEncryption)")
    //
    let access = try uplink.request_Access_With_Passphrase(satellite: storjSatellite, apiKey: storjApiKey, encryption: storjEncryption)
    //
    print("Access granted !!")
    print("Opening project on storj V3 network.....")
    //
    var project = try access.open_Project()
    defer {
        do {
            try project.close()
            print("\nProject closed !!")
        } catch {
           print(error)
        }
    }
    //
    //Creating bucket on storj V3 networks
    print("\nCreating bucket : ", storjBucket)
    let createBucketInfo = try project.create_Bucket(bucket: storjBucket)
    //
    print("Bucket name : ", createBucketInfo.name)
    print("Bucket information :\nBucket created : ", unixTimeConvert(unixTime: createBucketInfo.created))
    //
    //Ensuring bucket exits on storj V3 network
    print("\nGetting info about bucket : ", storjBucket)
    let statBucketInfo = try project.stat_Bucket(bucket: storjBucket)
    //
    print("Bucket name : ", statBucketInfo.name)
    print("Bucket information :\nBucket created : ", unixTimeConvert(unixTime: statBucketInfo.created))
    //
    // Listing buckets
    var listBucketsOptions = ListBucketsOptions(cursor: "")
    let bucketList = try project.list_Buckets(listBucketsOptions: &listBucketsOptions)
    //
    print("\nListing buckets...")
    for bucket in bucketList {
        print("Bucket Name : \(bucket.name)")
        print("Created On : \(unixTimeConvert(unixTime: bucket.created))")
    }
    //
    print("\nUploading object on storj V3 network...")
    //
    uploadObject(project: project, bucketName: storjBucket, localFullFileNameToUpload: localFullFileNameToUpload, storjUploadPath: storjUploadPath)
    //
    let statObject = try project.stat_Object(bucket: storjBucket, key: storjUploadPath)
    //
    print("\n\nStat Object \nObject name : \(statObject.key)")
    print("Object size : \(statObject.system.content_length)")
    print("Object created on : \(unixTimeConvert(unixTime: Int64(statObject.system.created)))")
    let customMetaDataList = statObject.custom.entries
    for customMetaData in customMetaDataList {
        print("Custom metaData key : \(customMetaData.key)")
        print("Custom metaData value : \(customMetaData.value)")
    }
    //
    print("\nDownloading object from storj V3 network...")
    //
    downloadObject(project: &project, bucketName: storjBucket, localFullFileLocationToStore: localFullFileLocationToStore, storjDownloadPath: storjDownloadPath)
    //
    var listObjectsOptions = ListObjectsOptions(prefix: "change-me-to-desired-prefix-with-/", cursor: "", recursive: true, system: true, custom: true)
    //
    let objectslist = try project.list_Objects(bucket: storjBucket, listObjectsOptions: &listObjectsOptions)
    print("\nList object")
    for object in objectslist {
        print("Object Name : \(object.key)")
        print("Object Size : \(object.system.content_length)")
    }
    //Deleting Object
    let deletedObject = try  project.delete_Object(bucket: storjBucket, key: storjUploadPath)
    print("\nObject deleted !!")
    print("Object Information : ")
    print("Object Name : \(deletedObject.key)")
    print("Object Size : \(deletedObject.system.content_length)")
    //
    print("\nCreating share access")
    //
    var permission = Permission(allow_download: true, allow_upload: true, allow_list: true, allow_delete: true, not_before: 0, not_after: 0)
    //
    let sharePrefix = SharePrefix(bucket: storjBucket, prefix: "change-me-to-desired-prefix-with-/")
    //
    var sharePrefixArray: [SharePrefix] = []
    sharePrefixArray.append(sharePrefix)
    //
    let accessShareResult = try access.share(permission: &permission, prefix: &sharePrefixArray)
    print("\nAccess Share Result")
    //
    let accessString = try accessShareResult.serialize()
    print("\nShared access created !!")
    print(accessString)
    //
    let parsedAccess = try uplink.parse_Access(stringKey: accessString)
    //
    var salt: [UInt8] = [4, 5, 6]
    //
    print("Deriving encryption key")
    //
    var encryption = try uplink.derive_Encryption_Key(passphrase: storjEncryption, salt: &salt)
    //
    let prefix = "change-me-to-desired-prefix-with-/"
    //
    print("Overriding Encryption key")
    //
    try parsedAccess.access_Override_Encryption_Key(bucket: storjBucket, prefix: prefix, encryptionKey: encryption)
    //
    //
    defer {
        uplink.free_Encryption_Key_Result(encryptionResult: &encryption)
    }
    //
    print("\nOpening project using shared access")
    var projectparsed = try parsedAccess.open_Project()
    defer {
        do {
        try projectparsed.close()
            print("\nProject closed !!")
        } catch {
            print("Failed to close project")
            print(error)
        }
    }
    //
    print("\nUploading object on storj V3 network via overridden serialized access...")
    //
    uploadObject(project: projectparsed, bucketName: storjBucket, localFullFileNameToUpload: localFullFileNameToUpload, storjUploadPath: storjUploadPath2)
    //
    //Deleting Object uploaded via overridden serialized access
    let deletedObject2 = try  projectparsed.delete_Object(bucket: storjBucket, key: storjUploadPath2)
    print("\nObject deleted !!")
    print("Object Information : ")
    print("Object Name : \(deletedObject2.key)")
    print("Object Size : \(deletedObject2.system.content_length)")
    //Deleting bucket
    let deleteBucket = try project.delete_Bucket(bucket: storjBucket)
    //
    print("\nBucket deleted!!")
    print("Bucket information :\nBucket created : ", unixTimeConvert(unixTime: deleteBucket.created))
    print("Bucket name : ", deleteBucket.name)
    //
    //
} catch let error as InternalError {
    print("Internal SO error")
    print("Error Code : \(error.code)")
    print("Error Message : \(error.message)")
} catch let error as LibUplinkSoError {
    print("LibUplink SO error")
    print("Error Code : \(error.code)")
    print("Error Message : \(error.message)")
} catch let error as BucketNotFoundError {
    print("Bucket Not found")
    print("Error Code : \(error.code)")
    print("Error Message : \(error.message)")
} catch let error as StorjException {
    print("Error Code : \(error.code)")
    print("Error Message : \(error.message)")
} catch {
    print("Error")
    print(error.localizedDescription)
}
