# Binding Functions


## Import libuplink  

```swift
import uplink_swift
```
## Include libuplink in library 

Storj("change-me-to-dylib-location") if not provided then default path will be uplink-swift/Sources/libUplink/include\
for example Storj("locationWhereStorjSwiftIsDownload/Sources/libUplink/include/libuplinkc.dylib")

```swift
let uplink = try Storj.uplink()
```
* we need to create an object of libUplink class that will be used to call the libuplink functions.


## request_Access_With_Passphrase(String, String, String)

##### Description:

This function request_access_with_passphrase  requests satellite for a new access grant
using a passphrase, there are no pre-requisites required for this function.\
This function accepts 3 arguments Satellite URL, API Key, and  encryption passphrase
and returns an AccessResult object on successful execution which can be used to 
call other functions which are bound to it.\
An access grant is a serialized structure that is internally comprised of an 
API Key, a set of encryption key information, and information about which Satellite
the address is responsible for the metadata.\
An access grant is always associated with exactly one Project on one Satellite.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>satelliteURL</code>| Storj V3 network satellite address | <code>String</code> |
|<code>apikey</code>| Storj V3 network API key |<code>String</code> |
|<code>encryptionpassphrase</code>| storj Encryption |<code>String</code> |


##### Usage Example:

```swift
var satelliteURL: String = "change-me-to-desired-satellite-address";
var storjapiKey: String = "change-me-to-desired-api-key";
var storjEncryption: String = "change-me-to-desired-encryption";

var accessResult = try storjSwift.request_Access_With_Passphrase(satellite: SatelliteURL, apiKey: storjApiKey, encryption: storjEncryption)
```

## parse_Access(String)


##### Description:

parse_access function to parses serialized access grant string there are no pre-requisites 
required for this function.\
this function accepts one argument serialized access String
which is returned by access_serialize function it returns an access object on successful 
execution which can be used to call other functions which are bound to it.\
This should be the main way to instantiate an access grant for opening a project.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>stringKey</code>| serialized access string returned by access_serialize function | <code>String</code> |

##### Usage Example:

```swift
var AccessResult = try storjSwift.parse_access(stringKey: stringKey)
```


## config_request_Access_With_Passphrase(config, String, String, String)

##### Description:

This function config_request_access_with_passphrase requests satellite for a new access grant 
using a passphrase and config.\
There are no pre-requisites required for this function.\
This function accepts 4 arguments Satellite URL, API Key, encryption passphrase, and config object and returns an AccessResult object on successful execution which can be used to call other functions that are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>config</code>| Create using storj library | <code>object</code> |
|<code>satelliteURL</code>|  Storj V3 network satellite address | <code>String</code> |
|<code>apikey</code>| Storj V3 network API key |<code>String</code> |
|<code>encryptionPassphrase</code>| any passphrase string |<code>String</code> |

##### Usage Example:

```swift
var satelliteURL: String = "change-me-to-desired-satellite-address"
var storjapiKey: String = "change-me-to-desired-api-key";
var storjEncryption: String = "change-me-to-desired-encryption"
var Config =  config()

var access = try storjSwift.config_request_Access_With_Passphrase(config: Config, satellite: SatelliteURL, apiKey: storjApiKey, encryption: storjEncryption)
```
    
## serialize()

##### Description:

access_serialize function serializes access grant into a string.\
parse access function is required as a pre-requisite for this function.
it returns a Serialized Access String on successful execution which is used to be as parse_access argument.


##### Usage Example:

```swift
do {
let accessString = try accessShareResult.serialize()
} catch {

}
```
 
## share(inout UplinkPermission, inout UnsafeMutablePointer(UplinkSharePrefix), Int)

##### Description:

access_share function creates a new access grant with specific permission. Permission will be
applied to prefixes when defined.
parse access function is required as a pre-requisite for this function.\
this function accepts 3 arguments 
permission(object) Permission defines what actions can be used to share which is access 
from storj Permission defines what actions can be used to share, sharePrefix(object) 
which is access from storj, and prefix count is getting from the count of share prefix 
in the list.\
It returns an access object on successful execution which can be used 
to call other functions that are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>permission</code>| Create using storj library |<code>object</code> |
|<code>SharePrefix</code>| Create using storj library |<code>object</code> |
|<code>PrefixCount</code>|count of share prefix |<code>Int</code> |

##### Usage Example:

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

## list_Buckets(inout ListBucketsOptions)


##### Description:

list_Buckets function lists buckets and open_project function is required
as a pre-requisite for this function. This function accepts 1 argument listBucketOptions which is access from storj library.\
it returns a bucket list object on successful execution it can be used to get other
properties that are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>listBucketOptions</code>| Create using storj library | <code>object</code> |

##### Usage Example:

```swift
// Listing buckets
var listBucketsOptions = UplinkListBucketsOptions(cursor: "")
let bucketList = try project.list_Buckets(listBucketsOptions: &listBucketsOptions)
```

## delete_Bucket(String)

##### Description:

delete_bucket function deletes a bucket When the bucket is not empty it returns ErrBucketNotEmpty.
and open_project function is required as a pre-requisite for this function .\
This function accepts 1 argument project(object) which is bucket name which is access from storj configuration.\
It returns a bucket object on successful execution it can be used to get other
properties that are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| access from storj configuration | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
let deleteBucket = try project.delete_Bucket(bucket: bucket)
```

## ensure_Bucket(String)

##### Description:

ensure_bucket function creates a new bucket and ignores the error when it 
already exists and open_project function is required as a pre-requisite.\
 This function accepts 1 argument bucket name which is access from storj configuration.\
It returns a bucket object on successful execution it can be used to get other properties 
which are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| bucket name on storj V3 network | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
let deleteBucket = try project.ensure_Bucket(bucket: bucket)
```


## create_Bucket(String)


##### Description:

create_bucket function creates a new bucket When bucket already exists it returns 
a valid Bucket and ErrBucketExists and open_project function is required
as a pre-requisite.\
This function accepts 1 argument bucket name which is access from storj 
configuration.\
It returns a bucket object on successful execution it can be 
used to get other properties that are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>|access from storj configuration | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
var createBucket = try  project.create_Bucket( bucket: bucket)
```

## stat_Bucket(String)

##### Description:

stat_bucket function returns information about a bucket and open_project function is 
required as a pre-requisite.\
This function accepts 1 argument project(object) which is a bucket name which is access from storj configuration.\
it returns a bucket object on successful execution it can be used to get
other properties that are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| Storj bucket name | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
let statBucket = try project.stat_Bucket(bucket: bucket)
```

## info()


##### Description:

info returns the metadata of downloading object, download_object 
function is required as a pre-requisite for this function.\
It returns an download object. On successful execution it can be used to get other properties which are bound to it.


##### Usage Example:

```swift
var ObjectResult = try download.info()
```

## close()


##### Description:

close function closes the download, download_object function is required as 
a pre-requisite for this function. This function accepts one argument 
download(object) which is returned by download_object function and it returns an error object, 
if successful execution is not occurred.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>download</code>| download object returned by download_object function | <code>object</code> |

##### Usage Example:

```swift
try download.close()
```

## read(UnsafeMutablePointer(UInt8), Int)

##### Description:

read function downloads from object's data stream into bytes up to length amount, 
download_object function is required as a pre-requisite for this function.\
This function accepts 2 argument buffer object which is access from allocated buffer and Length is length of the buffer.\
It returns an readresult object,
On successful execution it can be used to get other properties which are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>buffer</code>| Buffer | <code>UInt8</code> |
|<code>sizetowrite</code>| length of buffer | <code>Int</code> |

##### Usage Example:

```swift
var buffer = new Buffer.alloc(BUFFER_SIZE);

var ReadResult = try  download.read(data: ptrtoreceivedData, sizeToWrite: sizeToWrite)
```

## download_Object(String, String, UnsafeMutablePointer(DownloadOptions))

##### Description:

download_object function starts download to the specified key, open_project 
function is required as a pre-requisite for this function.\
This function accepts 3 argument bucket name 
which is access from storj configuration, ObjectKey which is access from storj 
configuration and downloadOptions which is access from storj library.\
It returns an download object, on successful execution it can be used to call other properties which are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| Bucket name on storj V3 network | <code>String</code> |
|<code>ObjectKey</code>| Object name already uploaded on storj V3 network | <code>String</code> |
|<code>downloadOptions</code>| Create using storj library | <code>object</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
var key: String = "change-me-to-desired-object-name-on-storj";
var downloadOptions =   UplinkDownloadOptions(offset: 0, length: -1);
var downloadResult = try  project.download_Object(bucket: bucketName, key: storjDownloadPath, downloadOptions: &downloadOptions)
```	

## stat_Object(String,String)


##### Description:

stat_object function information about an object at the specific key and 
open_project function is required as a pre-requisite for this function.\
This function accepts 2 argument bucket name which is access from storj configuration and Object Key which is access from storj configuration.\
It returns an objectinfo object on successful execution it can be used to get other
properties which are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| Bucket name on storj V3 network | <code>String</code> |
|<code>key</code>| Object name on storj V3 network | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
var key: String = "change-me-to-desired-object-name";
var ObjectResult = try project.stat_Object( bucket: &bucketName, key: &key)
```

## delete_Object(String, String)


##### Description:

delete_object function deletes an object at the specific key, open_project function is required as a pre-requisite 
for this function.\
This function accepts 2 argument bucket name which is access from storj configuration and ObjectKey
which is access from storj configuration.\
It returns an objectinfo object, on successful 
execution it can be used to get other properties which are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| Bucket name on storj V3 network | <code>String</code> |
|<code>key</code>| object name on storj V3 network | <code>String</code> |

##### Usage Example:

```swift
var bucket: String = "change-me-to-desired-bucket-name";
var key: String = "change-me-to-desired-object-name-on-storj";
var ObjectResult = try project.delete_Object( bucket: &bucketName, key: &key)

```

## list_Objects(String, inout UplinkListObjectsOptions)


##### Description:

list_objects function lists objects, open_project function is required as a pre-requisite 
for this function.\
This function accepts 2 argument bucket name which is access from storj configuration and listObjectOptions 
which is access from storj library ListObjectsOptions defines object listing options.\
it returns an objectList object, on successful execution it can be used to get 
other properties which are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| bucket name on storj V3 network | <code>String</code> |
|<code>listObjectOptions</code>| Create using storj library | <code>object</code> |

##### Usage Example:

```swift		
var listObjectsOptions = UplinkListObjectsOptions(prefix: "change-me-to-desired-prefix-with-/", cursor: "", recursive: true, system: false, custom: true)
//
let objectslist = try project.list_Objects(bucket: storjBucket, listObjectsOptions: &listObjectsOptions)
```

## close_Project()

##### Description:

close_project function closes the project and open_project function is required as a pre-requisite.\
It returns an error object if on successful execution is not occurred.


##### Usage Example:

```swift
try project.close()
```

## config_Open_Project(Config)


##### Description:

config_open_project function opens project using access grant and config.\
request_access_with_passphrase or config_request_access_with_passphrase function
is required as a pre-requisite. This function accepts 2 argument access(object)
which is returned by access function and config(object) which is access from storj
library.\
it returns an project object on successful execution which can be used to call 
other functions which are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>config</code>| Create using storj library | <code>object</code> |


##### Usage Example:

```swift
var Config =  config();
var projectResult = try access.config_open_project(config: &Config)

```

## open_Project()

##### Description:

Once you have a valid access grant, you can open a Project with the access that access grant,
open_project function opens project using access grant.\
request_access_with_passphrase or config_request_access_with_passphrase function is required as a pre-requisite.\
it returns a project object on successful execution which can be used to call 
other functions which are bound to it.\
It allows you to manage buckets and objects within buckets.


##### Usage Example:

```swift
var projectResult = try access.open_Project()

```


## info()


##### Description:

info function returns the last information about the uploaded object, upload_object function 
is required as a pre-requisite for this function. This function accepts one argument 
upload(object) which is returned by upload_object function.\
It returns an Object, on successful execution it can be used to get property which is bound to it.


##### Usage Example:

```swift
var ObjectResult = try upload.info()
```

## set_Custom_Metadata(CustomMetadata)


##### Description:

set_custom_metadata function set custom meta information, upload_object function 
is required as a pre-requisite for this function.\
This function accepts 1 argument CustomMetaData object which is access from storj library CustomMetadata contains custom user metadata about the object 
it returns an error object if successful execution does not occur.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>CustomMetaData</code>| Create using storj library | <code>object</code> |

##### Usage Example:

```swift
let keyString: String = "change-me-to-desired-key"
//
let entries = UplinkCustomMetadataEntry(key: keyString, key_length: keyString.count, value: keyString, value_length: keyString.count)
//
let entriesArray = [entries]
var customMetaDataObj = UplinkCustomMetadata(entries: entriesArray, count: entriesArray.count)
//
try upload.set_Custom_Metadata(customMetadata: &customMetaDataObj)
```

## abort()


##### Description:

abort function aborts an upload, upload_object function is required as a pre-requisite for this function.
if successful execution does not occur.


##### Usage Example:

```swift
try upload.abort()
```


## commit()

##### Description:

commit function commits the uploaded data, upload_object function is required as a pre-requisite for this function. if successful execution does not occur.


##### Usage Example:

```swift
try upload.commit()
```


## write(UnsafeMutablePointer(UInt8), Int)


##### Description:

write function uploads len(p) bytes from p to the object's data stream It returns the number of bytes written from p (0 <= n <= len(p)) and any error encountered that caused the write to stop early.\
upload_object function is required as a pre-requisite 
for this function. This function accepts 2 argument buffer object which is access from allocated buffer and 
Length is data file is being read it returns a writeresult object.\
On successful execution, it can be used to get other properties that are bound to it.

##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>buffer</code>| Buffer | <code>withUnsafeMutableBufferPointer</code> |
|<code>lenght</code>| length of data to be upload on storj V3 network | <code>Int</code> |

##### Usage Example:

```swift
// creating buffer to store data.data will be stored in buffer that needs to be uploaded
let data = fileHandle?.readData(ofLength: sizeToWrite)
//
var dataInUint = [UInt8](data.map {$0}!)
//
let dataBuffer = dataInUint.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
//
var dataUploadedOnStorj  = try upload.write(data: dataBuffer, sizeToWrite: sizeToWrite).
```

## upload_Object(String, String, UploadOptions)


##### Description:

upload_object function starts an upload to the specified key, open_project 
function is required as a pre-requisite for this function.\
This function accepts 3 argument bucket name 
which is accessible from storj configuration, ObjectKey which is access from storj 
configuration and uploadOptions which is access from storj library UploadOptions 
contains additional options for uploading.\
It returns an upload object, on successful execution it can be used to call other properties that are bound to it.


##### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucketName</code>| Bucket name on storj V3 network | <code>String</code> |
|<code>key</code>| Object name to be uploaded on storj V3 network | <code>String</code> |
|<code>uploadOptions</code>| Create using storj library | <code>object</code> |

##### Usage Example:

```swift		
var bucket: String = "change-me-to-desired-bucket-name";
var key: String = "change-me-to-desired-object-name-on-storj";
var uploadOptions =  UplinkUploadOptions();
var uploadResult = try project.upload_object(bucket: &bucketName, key: &key, uploadOptions: &uploadOptions)
```




> Note: You can view the libuplink documentation [here](https://godoc.org/storj.io/uplink).