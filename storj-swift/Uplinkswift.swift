//
//  storj.swift
//  storj-swift
//
//  Created by webwerks on 06/09/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation

public struct libUplinkSwift {
    var error : NSString
    var lO_uplinkRef : Uplink
    var lO_parsedAPIKeyRef : APIKey
    var lO_projectRef : Project
    var lO_encryptionRef : EncryptionAccess
    var lO_bucketRef : Bucket
    var debugMode : Bool
    //
    init() {
        self.error = ""
        self.lO_uplinkRef = Uplink()
        self.lO_parsedAPIKeyRef = APIKey()
        self.lO_projectRef = Project()
        self.lO_encryptionRef = EncryptionAccess()
        self.lO_bucketRef = Bucket()
        self.debugMode = false
    }
    
    /*
     * newUplink function creates a new Storj uplink.
     * pre-requisites: none
     * inputs: none
     * output: returns true, if successful, else false
     */
    mutating func newUplink()->Bool {
        //
        if (self.debugMode) {
            print(" Setting-up new uplink...")
        }
        //
        let uplinkConfig = UplinkConfig()
        //
        // create pointer to error string
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        // call golang function to create a new uplink
        self.lO_uplinkRef = uplink_custom(uplinkConfig, &errorPtr)
        //
        if (self.lO_uplinkRef._handle > 0) {
            if (self.debugMode) {
                print(" New uplink: SET-UP!")
            }
            //
            return true
        } else {
            if (self.debugMode) {
                print(" FAILed to set-up new uplink!")
            }
            //
            return false
        }
    }
    
    /*
     * parseAPIKey function parses the API key, to be used by Storj.
     * pre-requisites: none
     * inputs: API key (NSString)
     * output: returns true, if successful, else false
     */
    mutating func parseAPIKey(apiKey :NSString)->Bool {
        if(self.debugMode){
            print(" Parsing the API Key: ", apiKey)
        }
        // create pointer to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        // create pointer to API key
        let apiKeyPtr = UnsafeMutablePointer<CChar>(mutating: apiKey.utf8String)
        //
        self.lO_parsedAPIKeyRef = parse_api_key(apiKeyPtr, &errorPtr)
        if (self.lO_parsedAPIKeyRef._handle>0) {
            return true
        }else{
            if(self.debugMode){
                print(" FAILed to parse the API!")
            }
            return false
        }
    }
    
    /*
     * openProject function to opens a Storj project.
     * pre-requisites: uplink() and parseAPIKey() functions have been already called
     * inputs: Satellite Address (NSString)
     * output: returns true, if successful, else false
    */
    mutating func openProject(satellite :NSString)->Bool {
        if(self.debugMode){
            print(" Opening project from satellite: ",satellite)
        }
        //Creating ponter to error
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //Creating Ptr to satellite address
        let satellitePtr = UnsafeMutablePointer<CChar>(mutating: satellite.utf8String)
        self.lO_projectRef = open_project(self.lO_uplinkRef,satellitePtr,lO_parsedAPIKeyRef,&errorPtr)
        if(self.lO_parsedAPIKeyRef._handle>0){
            return true
        }else{
            if(self.debugMode){
                print(" FAILed to open the project!")
            }
            return false
        }
    }
    /*
     * function to get encryption access to upload and download data on Storj
     * pre-requisites: openProject() function has been already called
     * inputs: Encryption Pass Phrase (NSString)
     * output: returns true, if successful, else false
     */
    mutating func encryptionKey(encryptionPassphrase :NSString)-> Bool{
        if(self.debugMode){
            print(" Creating Encryption key!")
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        let encryptionpassphrasePtr = UnsafeMutablePointer<CChar>(mutating: encryptionPassphrase.utf8String)
            self.lO_encryptionRef = encryption_key_custom(self.lO_projectRef, encryptionpassphrasePtr, &errorPtr)
            print(self.lO_encryptionRef)
            if(self.lO_encryptionRef._handle > 0){
                return true
            }else{
                if(self.debugMode){
                    print(" FAILed to parse the encryption pass phrase!")
                }
                return false
            }
    
    }
    
    /*
     * function to open an already existing bucket in Storj project
     * pre-requisites: encryptionKey() function has been already called
     * inputs: Bucket Name (NSString)
     * output: returns true, if successful, else false
    */
    mutating func openBucket(bucket :NSString)->Bool{
        if(self.debugMode){
            print(" Opening bucket ",bucket)
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        let bucketnamePtr = UnsafeMutablePointer<CChar>(mutating: bucket.utf8String)
        self.lO_bucketRef = open_bucket_custom(lO_projectRef, bucketnamePtr, lO_encryptionRef, &errorPtr)
        if(self.lO_bucketRef._handle > 0){
            return true
        }else{
            if(self.debugMode){
                print(" FAILed to open the bucket!")
            }
            return false
        }
    
    }
    
    /*
     * function to upload data from srcFullFileName (at local computer) to Storj (V3) bucket's path
     * pre-requisites: openBucket() function has been already called
     * inputs: Storj Path/File Name (NSString) within the opened bucket, local Source Full File Name(NSString)
     * output: returns true, if successful, else false
    */
    mutating func upload(storjUploadPath :NSString, localFullFilename :NSString){
        if(self.debugMode){
            print(" Uploading Object...")
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        let fileuploadpathPtr = UnsafeMutablePointer<CChar>(mutating: storjUploadPath.utf8String)
        let fullfilenamePtr = UnsafeMutablePointer<CChar>(mutating: localFullFilename.utf8String)
        let blank : NSString = ""
        if((localFullFilename != blank) && (storjUploadPath != blank))
        {
         upload_custom(lO_bucketRef, fileuploadpathPtr, fullfilenamePtr, &errorPtr)
        }
        else
        {
            if(localFullFilename == blank){
                print(" Please enter localFullFilename for Uploading Object")
            }
            if(storjUploadPath == blank){
                print(" Please enter storjUploadPath for Uploading Object")
            }
        }
    }
    
    /*
     * function to download Storj (V3) object's data and store it in given file with destFullFileName (on local computer)
     * pre-requisites: openBucket() function has been already called
     * inputs: Storj Path/File Name (NSString) within the opened bucket, local Destination Full Path Name(NSString)
     * output: returns true, if successful, else false
     */
    mutating func download(storjFullFilename :NSString,localFullFilename :NSString){
        if(self.debugMode){
            print(" Downloading object....")
        }
        //
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        let fileManger = FileManager.default
        //
        let path = fileManger.currentDirectoryPath
        //
        var locationDownloadFullFilename : NSString = ""
        //
        let blank : NSString = ""
        //
        let list = storjFullFilename.components(separatedBy: "/")
        if((storjFullFilename != blank) && (localFullFilename != blank)) {
                if(localFullFilename.contains("/")){
                    let localfilelist = localFullFilename.components(separatedBy: "/")
                    if(localfilelist[localfilelist.count-1].contains(".")) {
                        locationDownloadFullFilename = localFullFilename
                        
                    }else{
                        locationDownloadFullFilename = (localFullFilename) as String + list[list.count-1] as NSString
                    }
                }else{
                    locationDownloadFullFilename = path + list[list.count-1] as NSString
                }
        
        
          let storjFullFilenamePointer = UnsafeMutablePointer<CChar>(mutating: storjFullFilename.utf8String)
          let localFullFilenamePointer = UnsafeMutablePointer<CChar>(mutating: localFullFilename.utf8String)
          download_custom(lO_bucketRef, storjFullFilenamePointer, localFullFilenamePointer, &errorPtr)
        }
        else
        {
            if(storjFullFilename == blank) {
                print(" Plese enter storjFullFilename for downloading object ")
            }
            if(localFullFilename == blank)
            {
                print(" Please enter localFullFilename for downloading object ")
            }
        }
    }
    /*
     * function to create new bucket in Storj project
     * pre-requisites: open_project() function has been already called
     * inputs: Bucket Name (NSString)
     * output: returns true, if successful, else false
     */
    mutating func createBucket(bucket :NSString)->Bool {
        if(self.debugMode){
            print(" Creating " ,bucket, " bucket...")
        }
        //
        var bucketconfig = BucketConfig()
        //
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        //
        let bucketnamePtr = UnsafeMutablePointer<CChar>(mutating: bucket.utf8String)
        //
        let bucketconfigPtr = UnsafeMutablePointer<BucketConfig>(&bucketconfig)
        //
        let lO_bucketInfo = create_bucket(lO_projectRef, bucketnamePtr, bucketconfigPtr,&errorPtr)
        //
        if(lO_bucketInfo.name != nil){
            if(self.debugMode) {
                print(" Bucket created !")
            }
            return true
        }else{
            if(self.debugMode) {
                print(" Bucket not created")
            }
            return false
        }
    }
    /*
     * function to close currently opened Bucket
     * pre-requisites: open_bucket() function has been already called, successfully
     * inputs: none
     * output: returns true, if successful, else false
     */
    mutating func closeBucket(){
        if(self.debugMode){
            print(" Close Bucket.....")
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        close_bucket(lO_bucketRef, &errorPtr)
    }
    /*
     * function to close currently opened Storj project
     * pre-requisites: open_project() function has been already called
     * inputs: none
     * output: returns true, if successful, else false
     */
    mutating func closeProject(){
        if(self.debugMode){
            print(" Close Project.....")
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        close_project(lO_projectRef, &errorPtr)
    }
    /*
     * function to close currently opened uplink
     * pre-requisites: new_uplink() function has been already called
     * inputs: none
     * output: returns true, if successful, else false
     */
    mutating func closeUplink(){
        if(self.debugMode){
            print(" Close Uplink.....")
        }
        var errorPtr = UnsafeMutablePointer<CChar>(mutating: error.utf8String)
        close_uplink(lO_uplinkRef, &errorPtr)
    }   
}
