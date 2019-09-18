//
// main.swift
// example Swift code, utilizing storj-swift bindings
//

import Foundation
import storj


/* Storj V3 network configuration parameters */
//
// API key
var storjApiKey : NSString = "13Yqf9SJhb9ApNZQdY2H4h47pacMyQeAtGafLUygWhTuugCU17P5BffEZveFnP8ivv2dsrWFaKPZJnRupHHgkw9abTw3hzxpHt2td5Y"
// Satellite address
var storjSatellite : NSString = "us-central-1.tardigrade.io:7777"
// Encryption passphrase
var storjEncryptionPassphrase : NSString = "test"
// Bucket name
var storjBucket : NSString = "macbucket07"
//
// Upload path within the bucket, whereto the sample message is to be uploaded.
var storjUploadPath : NSString = "path/hellostorj.txt"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath : NSString = "path/hellostorj.txt"

// Full file name, including path, of the local system, to be uploaded to Storj bucket.
var localFullFileNameToUpload : NSString = "/Users/webwerks/swift/src/storj-swift/sample.txt"
// Local full path, where the Storj object is to be stored after download.
var localFullFileLocationToStore : NSString = "/Users/webwerks/swift/src/test.txt"


// Create an object of the Storj-Swift bindings, so as to access functions.
var lO_libUplinkSwift = libUplinkSwift()

print("Setting-up a New Uplink...")
// Create a new uplink.
let (lO_uplinkRef, uplinkError) = lO_libUplinkSwift.newUplink()
//
if uplinkError == "" {
    print("New Uplink: SET-UP!\nParsing the API Key: ", storjApiKey)
    //
    let (lO_parseAPIKeyRef, parseAPIKeyError) = lO_libUplinkSwift.parseAPIKey(apiKey: storjApiKey)
    //
    if parseAPIKeyError == "" {
        print("API key: PARSED!\nOpening the Storj Project from Satellite: ", storjSatellite)
        //
        let (lO_ProjectRef, openProjectError) = lO_libUplinkSwift.openProject(lO_uplinkRef: lO_uplinkRef, satellite: storjSatellite, lO_parsedAPIKeyRef: lO_parseAPIKeyRef)
        //
        if openProjectError == "" {
            print("Desired Storj Project: OPENED!\nCreating a new bucket with name, ", storjBucket, " ...")
            //
            let (lO_BucketInfo, createBucketError) = lO_libUplinkSwift.createBucket(lO_projectRef: lO_ProjectRef, bucketName: storjBucket)
            //
            if createBucketError != "" {
                print("FAILed to create a new bucket!")
                print(createBucketError)
            } else {
                print("New Bucket: CREATED!")
            }
            print("Accessing given Encryption Phasshrase...")
            //
            let (ptrSerializedAccess, encryptionKeyError) = lO_libUplinkSwift.getEncryptionAccess(lO_projectRef: lO_ProjectRef, encryptionPassphrase: storjEncryptionPassphrase)
            //
            if ptrSerializedAccess != nil {
                print("Encryption Access: RECEIVED!\nOpening ", storjBucket, " Bucket...")
                //
                let (lO_OpenBucket, openBucketError) = lO_libUplinkSwift.openBucket(lO_projectRef: lO_ProjectRef, bucket: storjBucket, ptrSerialAccess: ptrSerializedAccess)
                //
                if openBucketError == "" {
                    print(storjBucket, " Bucket: OPENED!", "\nUploading ", localFullFileNameToUpload, "file to the Storj Bucket...")
                    //
                    let uploadError = lO_libUplinkSwift.uploadFile(lO_bucketRef: lO_OpenBucket,  storjUploadPath: storjUploadPath, localFullFileNameToUpload: localFullFileNameToUpload)
                    //
                    if uploadError == "" {
                        //
                        print(localFullFileNameToUpload, " FILE : UPLOADED as ", storjUploadPath, " file...")
                        //
                        print("Downloading ", storjUploadPath, " Storj Object as ", localFullFileLocationToStore, " file...")
                        let downloadError = lO_libUplinkSwift.downloadFile(lO_bucketRef: lO_OpenBucket,  storjFullFilename: storjDownloadPath, localFullFilename: localFullFileLocationToStore)
                        //
                        if downloadError != "" {
                            print("FAILed to download ", localFullFileLocationToStore, "object from the storj bucket")
                            print(downloadError)
                        } else {
                            print("Storj Bucket's ", storjUploadPath, " object Downloaded as ", localFullFileLocationToStore, " file!")
                        }
                        
                    } else {
                        print("FAILed to upload ", localFullFileNameToUpload , " object from the Storj bucket!")
                        print(uploadError)
                    }
                    //
                    print("Closing the Opened Bucket...")
                    let closeBucketError = lO_libUplinkSwift.closeBucket(lO_bucketRef: lO_OpenBucket)
                    if closeBucketError != "" {
                        print("FAILed to close desired bucket!")
                        print(closeBucketError)
                    } else {
                        print("Desired Bucket: CLOSED!")
                    }
                } else {
                    print("FAILed to open desired bucket!")
                    print(openBucketError)
                }
            } else {
                print("FAILed to get encryption access from given passphrase")
                print(encryptionKeyError)
            }
            //
            print("Closing the opened Storj Project...")
            let closeProjectError = lO_libUplinkSwift.closeProject(lO_projectRef: lO_ProjectRef)
            if closeProjectError != "" {
                print("FAILed to close the project!")
                print(closeProjectError)
            } else {
                print("Storj Project: CLOSED!")
            }
        } else {
            print("FAILed to open desired Storj project!")
            print(openProjectError)
        }
    } else {
        print("FAILed to parse the API key!")
        print(parseAPIKeyError)
    }
    //
    print("Closing the established Storj Uplink...")
    let closeUplinkError = lO_libUplinkSwift.closeUplink(lO_uplinkRef: lO_uplinkRef)
    if closeUplinkError != "" {
        print("FAILed to close uplink")
        print(closeUplinkError)
    }
} else {
    print("FAILed to set-up a new uplink!")
    print(uplinkError)
}

