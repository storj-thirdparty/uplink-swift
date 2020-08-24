# Tutorial

> Welcome to the tutorial of creating a project by yourself. Let's start!

## Step 1: Import required modules

You need to import the following modules first

```swift
import uplink_swift
```

## Step 2: Storj Configurations

First and foremost you need to have all the keys and configuration to connect to the storj network. You can simply initialize the corresponding variables inside the main method as done in the sample *main.swift* file in the following way:

```swift
var storjApiKey: String = "change-me-to-desired-api-key"
var storjSatellite: String = "us-central-1.tardigrade.io:7777"
var storjEncryption: String = "change-me-to-desired-encryptionphassphrase"
var storjBucket: String = "change-me-to-desired-bucket-name"
var storjUploadPath: String = "path/filename.txt"
var storjDownloadPath: String = "path/filename.txt"
```

## Step 3: File Path

Simply initialize file path variable(s) as done in the sample *main.swift* file in the following way:

```swift
var localFullFileNameToUpload: String = "change-me-to-fullfilepath-on-local-system"
var localFullFileLocationToStore: String = "change-me-to-desired-fullfile-name"
```

## Step 4: Create libUplink class object

Next, you need to create an object of libUplink class that will be used to call the libuplink functions.

```swift
//Storj("change-me-to-dylib-location") if not provided then default path will be uplink-swift/Sources/libUplink/include
//for example Storj("locationWhereStorjSwiftIsDownload/Sources/libUplink/include/libuplinkc.dylib")
let uplink = try Storj.uplink()
```

> NOTE: Make sure you are calling uplink functions inside do-catch block.

## Step 5: Create access handle

Now we need to get access handle to Storj V3 network in the following way:
  
```swift
var access = try uplink.request_Access_With_Passphrase(satellite: storjSatellite, apiKey: storjApiKey, encryption: storjEncryption)
```

> NOTE: Make sure you are calling uplink functions inside do-catch block.

## Step 6: Open Project

Once we have the Access handle, it can be used to open a project as following.

```swift
var project = try access.open_Project()
```

## Step 7: Create/Ensure Bucket

After getting a project result we need a bucket for further execution. If a bucket is not available, one is created otherwise information about the current bucket is collected and execution moves ahead.

We use *stat_Bucket* function to get information about the bucket.

### stat_Bucket

```swift
var bucketResult = try project.stat_Bucket(bucket: storjBucket)
```

> NOTE: If the specified bucket does not exist, it is created using the function below

### create_Bucket

```swift
var createBucketResultObj = try  project.create_Bucket(bucket: storjBucket)
```

> After creating the bucket, it is important to ensure that the bucket exists on Storj V3 network before moving ahead.

### ensure_Bucket

```swift
var ensureBucketResult = try  project.ensure_Bucket(bucket: storjBucket)
```

## Step 8: List Buckets (Optional)

Once it is ensured that bucket exists on Storj V3 network, you can list all the buckets. However this step is completely optional. If you don't wish to list the buckets, you can skip this step.


### Listing the buckets

After getting the bucketIterator, you can run a loop to list buckets one by one as done in this example.

```swift
var listBucketsOptions = UplinkListBucketsOptions(cursor: "")
let bucketList = try project.list_Buckets(UplinkListBucketsOptions: &listBucketsOptions)
```

## Step 9: Upload

Uploading a file consists of following sub-steps:

### Create file handle
  
```swift
let fileManager = FileManager.default
let fileDetails = try fileManager.attributesOfItem(atPath: localFullFileNameToUpload as String)
let totalFileSizeInBytes: Int = fileDetails[FileAttributeKey.size] as? Int ?? Int(0)
let fileHandle = FileHandle(forReadingAtPath: localFullFileNameToUpload as String)
```

### Create upload handle

To stream the data to storj you need to create a file stream or handle which can be done in the following way.

```swift
var totalBytesRead = 0
var sizeToWrite = 0
var uploadOptions = UplinkUploadOptions()
var upload = try project.upload_Object(bucket: bucketName, key: storjUploadPath, uploadOptions: &uploadOptions)
```

You can create *uploadOptions* by referring to the [libuplink documentation](https://godoc.org/storj.io/uplink) or simply pass *none*.

### Create Buffer:

Now we need to create buffer to store our file's data. It can be done in the following way.

```swift
let bufferSize = 1000000

var breakloop = false


while totalBytesRead<totalFileSizeInBytes {
  if totalFileSizeInBytes-totalBytesRead > bufferSize {
    sizeToWrite = bufferSize
  } else {
    sizeToWrite = totalFileSizeInBytes-totalBytesRead
  }
  if totalBytesRead>=totalFileSizeInBytes {
    break
  }
```

> NOTE: bufferSize can be set as per your convenience and requirement.

### Upload File:

Once we have the File Handle and Buffer, we can upload data to Storj V3 network in the following way:

```swift
do {
  let data = fileHandle?.readData(ofLength: sizeToWrite)
  var dataInUint = [UInt8](data.map {$0}!)
  let dataBuffer = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
  var bytesWritten = try  upload.write(data: dataBuffer, sizeToWrite: sizeToWrite)
```

## Step 10: Download
  
Downloading a file consists of following steps:

### Create Download Handle:
  
We need to create a download handle first in the following way. In the code, download is your download handle. 
  
```swift
var downloadOptions = DownloadOptions(offset: 0, length: -1)
var download = try  project.download_Object(bucket: bucketName, key: storjDownloadPath, downloadOptions: &downloadOptions)
```

### Creating download buffer and file handle:

Now we need to create a download buffer and file handle in the same way as we did for upload.

```swift

  let fileManger = FileManager.default
  let writehandel = FileHandle(forWritingAtPath: localFullFileLocationToStore as String)

  let bufferSize = 1000000
  let sizeToWrite = bufferSize
  var downloadTotal = 0
  var buff = Data(capacity: bufferSize)
```

### Downloading the object:

Now we can download the object from Storj V3 server using the following function.

```swift
var receivedDataArray: [UInt8] = Array(repeating: 0, count: sizeToWrite)
let ptrtoreceivedData = receivedDataArray.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
//
var ptrToReadResult = try  download.read(data: ptrtoreceivedData, sizeToWrite: sizeToWrite)
```

### Closing the file handle:

When the file is downloaded, you need to close the file handle. It can be done in the following way:

```swift
if writehandel != nil {
  writehandel?.closeFile()
}
```

### close Download:

Now you need to close the download stream. 

```swift
_ = try download.close()
```

> NOTE: Perform error handling as as per your implmentation.

> NOTE: Alternatively, you can simple create a method(s) that can be called from the main method and performs upload and download steps internally as done in the sample file.

## Step 11: List Objects (Optional)

To list all the objects that are present in your bucket on Storj V3 network, follow these steps:


### Listing Objects:


```swift
var listObjectsOptions = UplinkListObjectsOptions(prefix: "change-me-to-desired-prefix-with-/", cursor: "", recursive: true, system: false, custom: true)
//
let objectslist = try project.list_Objects(bucket: storjBucket, listObjectsOptions: &listObjectsOptions)

for object in objectslist {
  print("Object Name : \(object.key)")
}
```

> NOTE: You can perform error handling as per your convenience. Also make sure to free the objectIterator object, once its purpose is fulfilled.

## Step 12: Generating Shared Access (Optional)
  
To generate shared access, do the following:

```swift
// set permissions for the new access to be created
var permission = UplinkPermission(allow_download: true, allow_upload: true, allow_list: true, allow_delete: true, not_before: 0, not_after: 0)
//
let sharePrefix = UplinkSharePrefix(bucket: storjBucket, prefix: "change-me-to-desired-prefix-with-/")
//
var sharePrefixArray: [UplinkSharePrefix] = []
sharePrefixArray.append(sharePrefix)
//
let accessShareResult = try access.share(permission: &permission, prefix: &sharePrefixArray)
```

## Step 13: Delete Bucket

To delete a bucket, we can use the following function:

```swift
do {
  var deleteBucketResult = try project.delete_Bucket(bucket: storjBucket)
} catch {

}
```

## Step 14: Close Project 

After finalizing everything, you can close the project in following way;

```swift
do {
 try project.close()
} catch {
  print(error)
}
```

