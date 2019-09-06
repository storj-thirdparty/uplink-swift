//
//  main.swift
//  storj-swift
//
//  Created by webwerks on 06/09/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation


/* Storj V3 network configuration parameters */
//
// API key
var storjApiKey : NSString = "13Yqf9SJhb9ApNZQdY2H4h47pacMyQeAtGafLUygWhTuugCU17P5BffEZveFnP8ivv2dsrWFaKPZJnRupHHgkw9abTw3hzxpHt2td5Y"
// Satellite address
var storjSatellite : NSString = "us-central-1.tardigrade.io:7777"
// Encryption passphrase
var storjEncryptionPassphrase : NSString = "test"
// Bucket name
var storjBucket : NSString = "macbucket02"
//
// Upload path within the bucket, whereto the sample message to be uploaded.
var storjUploadPath : NSString = "hellostorj.txt"
// Download path within the bucket, wherefrom the Storj object is to be downloaded.
var storjDownloadPath : NSString = "hellostorj.txt"

// Full file name, including path, of the local file, to be uploaded to Storj bucket.
var localFullFileNameToUpload : NSString = "/Users/sample.txt"
// Local full path, where the Storj object is to be stored.
var localFullFileLocationToStore : NSString = "/Users"


// Create an object of the Storj-Swift bindings, so as to access functions.
var lO_libUplinkSwift = libUplinkSwift()
//
// (optional) enable/disable debug mode
lO_libUplinkSwift.debugMode = true
//
// Create a new uplink.
if (lO_libUplinkSwift.newUplink()) {
    // Parse the API key, that corresponds to desired Storj project.
    if (lO_libUplinkSwift.parseAPIKey(apiKey: storjApiKey)) {
        // Open the Storj project through appropriate satellite.
        if (lO_libUplinkSwift.openProject(satellite: storjSatellite)) {
            // Create a new bucket within the Storj project.
            if (lO_libUplinkSwift.createBucket(bucket: storjBucket)) {
                // Create encryption key from given passphrase.
                if (lO_libUplinkSwift.encryptionKey(encryptionPassphrase: storjEncryptionPassphrase)) {
                    // Open the newly created Storj bucket to process objects.
                    if (lO_libUplinkSwift.openBucket(bucket: storjBucket)) {
                        // Upload a local file to given upload path in the Storj bucket.
                        lO_libUplinkSwift.upload(storjUploadPath: storjUploadPath, localFullFilename: localFullFileNameToUpload)
                        //
                        // Download desired object from Storj bucket to local system.
                        lO_libUplinkSwift.download(storjFullFilename: storjDownloadPath, localFullFilename: localFullFileLocationToStore)
                        //
                        // Close the opened Storj bucket.
                        lO_libUplinkSwift.closeBucket()
                    }
                }
            }
            // Close the opened Storj project.
            lO_libUplinkSwift.closeProject()
        }
    }
    // Close the opened Storj uplink.
    lO_libUplinkSwift.closeUplink()
}

