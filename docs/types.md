# Types, Errors and Constants

## Types

### UplinkConfig(String, Int, String)

#### Description:

Config defines configuration for using uplink library.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>user_agent</code>| Name of the partner | <code>string</code> |
|<code>dial_timeout_milliseconds</code>| How long client should wait for establishing a connection to peers. | <code>int</code> |
|<code>temp_directory</code>| Where to save data during downloads to use less memory. | <code>string</code> |

#### Usage Example

```swift
from uplink_python.module_classes import Config

var config = UplinkConfig()
do {
	
	project = access.config_Open_Project(config:config)

} catch {

}
```

### UplinkPermission(String, String, String, String, Int, Int)

#### Description:

UplinkPermission defines what actions can be used to share.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>allow_download</code>| Gives permission to download the object's content |<code>string</code> |
|<code>allow_upload</code>| Gives permission to create buckets and upload new objects |<code>string</code> |
|<code>allow_list</code>| Gives permission to list buckets |<code>string</code> |
|<code>allow_delete</code>| Gives permission to delete buckets and objects |<code>string</code> |
|<code>not_before</code>| Restricts when the resulting access grant is valid for |<code>int</code> |
|<code>not_after</code>| Restricts when the resulting access grant is valid till |<code>int</code> |

#### Usage Example

```swift

var permission = UplinkPermission(allow_download: true, allow_upload: true, allow_list: true, allow_delete: true, not_before: 0, not_after: 0)

do {
	//
	let accessShareResult = try access.share(permission: &permission, prefix: &sharePrefixArray)
	//
	} catch {

	}
```

### UplinkSharePrefix(String, String)

#### Description:

UplinkSharePrefix defines a prefix that will be shared.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>bucket</code>| Bucket name on storj V3 network | <code>string</code> |
|<code>prefix</code>| Prefix is the prefix of the shared object keys | <code>string</code> |

>Note: that within a bucket, the hierarchical key derivation scheme is delineated by forward slashes (/), so encryption information will be included in the resulting access grant to decrypt any key that shares the same prefix up until the last slash.

#### Usage Example

```swift


let sharePrefix = UplinkSharePrefix(bucket: storjBucket, prefix: "change-me-to-desired-prefix-with-/")
    //
    var sharePrefixArray: [UplinkSharePrefix] = []
    sharePrefixArray.append(sharePrefix)

do {
	let accessShareResult = try access.share(permission: &permission, prefix: &sharePrefixArray)

	} catch {

	}
```

### UplinkBucket(String, Int)

#### Description:

UplinkBucket contains information about the bucket.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>name</code>| Bucket name on storj V3 network | <code>string</code> |
|<code>created</code>| Time of bucket created on storj V3 network | <code>int</code> |


#### Usage Example

```swift
do {
	let createBucketInfo = try project.create_Bucket(bucket: storjBucket)
	} catch {

	}
```

### UplinkCustomMetadata(List, Int)

#### Description:

UplinkCustomMetadata contains a list of CustomMetadataEntry about the object.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>entries</code>| List of CustomMetadataEntry about the object | <code>list of objects</code> |
|<code>count</code>| Number of entries | <code>int</code> |


#### Usage Example

```swift
do {
	let keyString: String = "change-me-to-desired-key"
    //
    let entries = UplinkCustomMetadataEntry(key: keyString, key_length: keyString.count, value: keyString, value_length: keyString.count)
    //
    let entriesArray = [entries]
    var customMetaDataObj = UplinkCustomMetadata(entries: entriesArray, count: entriesArray.count)
    //
    try upload.upload_Set_Custom_Metadata( customMetadata: &customMetaDataObj)
	} catch {

	}
```

### UplinkCustomMetadataEntry(String, Int, String, Int)

#### Description:

UplinkCustomMetadata contains custom user metadata about the object.

When choosing a custom key for your application start it with a prefix "app:key",
as an example application named"Image Board" might use a key "image-board:title".

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>key</code>| Key | <code>string</code> |
|<code>key_length</code>| Length of key | <code>int</code> |
|<code>value</code>| Value | <code>string</code> |
|<code>value_length</code>| Length of value | <code>int</code> |


#### Usage Example

```swift
do {
	let keyString: String = "change-me-to-desired-key"
    //
    let entries = UplinkCustomMetadataEntry(key: keyString, key_length: keyString.count, value: keyString, value_length: keyString.count)
    //
    let entriesArray = [entries]
    var customMetaDataObj = UplinkCustomMetadata(entries: entriesArray, count: entriesArray.count)
    //
    try upload.upload_Set_Custom_Metadata( customMetadata: &customMetaDataObj)
	} catch {

	}
```

### UplinkSystemMetadata(Int, Int, Int)

#### Description:

UplinkSystemMetadata contains information about the object that cannot be changed directly.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>created</code>| Time when object was created | <code>int</code> |
|<code>expires</code>| Time till when object was be valid | <code>int</code> |
|<code>content_length</code>| Size of the object | <code>int</code> |


#### Usage Example

```swift
do {
	//
	let deletedObject = try  project.delete_Object(bucket: storjBucket, key: storjUploadPath)
	print(deletedObject.system.created)
	//
	} catch {

	}
```

### UplinkObject(String, Bool, Object, Object)

#### Description:

UplinkObject contains information about an object.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>key</code>| Object path on storj V3 network | <code>string</code> |
|<code>is_prefix</code>| is_prefix indicates whether the Key is a prefix for other objects | <code>bool</code> |
|<code>system</code>| SystemMetadata contains information about the object | <code>object</code> |
|<code>custom</code>| CustomMetadata contains a list of CustomMetadataEntry about the object | <code>object</code> |

#### Usage Example

```swift
do {
	let statObject = try project.stat_Object(bucket: storjBucket, key: storjUploadPath)
	print(statObject.key)
	print(statObject.system.created)
	print(statObject.custom.count)
	} catch {

	}
```

### UplinkListObjectsOptions(String, String, Bool, Bool, Bool)

#### Description:

UplinkListObjectsOptions defines object listing options.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>prefix</code>| Prefix allows to filter objects by a key prefix. If not empty, it must end with slash | <code>string</code> |
|<code>cursor</code>| Cursor sets the starting position of the iterator. The first item listed will be the one after the cursor | <code>string</code> |
|<code>recursive</code>| Recursive iterates the objects without collapsing prefixes | <code>bool</code> |
|<code>system</code>| System includes SystemMetadata in the results | <code>bool</code> |
|<code>custom</code>| Custom includes CustomMetadata in the results | <code>bool</code> |


#### Usage Example

```swift
do {
		var listObjectsOptions = UplinkListObjectsOptions(prefix: "change-me-to-desired-prefix-with-/", cursor: "", recursive: true, system: false, custom: true)
		//
		let objectslist = try project.list_Objects(bucket: storjBucket, listObjectsOptions: &listObjectsOptions)
		//
	} catch {

	}
```

### UplinkListBucketsOptions(String)

#### Description:

UplinkListBucketsOptions defines bucket listing options.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>cursor</code>| Cursor sets the starting position of the iterator. The first item listed will be the one after the cursor | <code>string</code> |

#### Usage Example

```swift
do {
		//
		var listBucketsOptions = UplinkListBucketsOptions(cursor: "")
    	//
    	let bucketList = try project.list_Buckets(listBucketsOptions: &listBucketsOptions)
	} catch {

	}
```

### UplinkUploadOptions(Int)

#### Description:

UplinkUploadOptions contains additional options for uploading.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>expires</code>| When expires is 0 or negative, it means no expiration | <code>int</code> |

#### Usage Example

```swift
do {
		var uploadOptions = UplinkUploadOptions()
        //
        var upload = try project.upload_Object(bucket: bucketName, key: storjUploadPath, uploadOptions: &uploadOptions)
        //
	} catch {

	}
```

### UplinkDownloadOptions(Int, Int)

#### Description:

UplinkDownloadOptions contains additional options for downloading.

#### Arguments:

| arguments | Description |  Type |
| --- | --- | --- |
|<code>offset</code>| Offset to the download object | <code>int</code> |
|<code>length</code>| When length is negative, it will read until the end of the blob | <code>int</code> |

#### Usage Example

```swift
do {
		var downloadOptions = UplinkDownloadOptions(offset: 0, length: -1)
        //
        let download = try  project.download_Object(bucket: bucketName, key: storjDownloadPath, downloadOptions: &downloadOptions)
	} catch {
		print(error)
	}
```

## Errors

### StorjException

#### Description:

StorjException is a broad category of all the errors thrown from uplink functions.\
It can be used to catch error thrown from uplink when one does not know what exception can be thrown from a particular function.

#### Returns:

| Returns | Description |  Type |
| --- | --- | --- |
|<code>code</code>| Error code related to error | <code>int</code> |
|<code>message</code>| Detailed description of the error  |<code>string</code> |

#### Usage Example

```swift
do {

} catch let error as StorjException {
    print("Error Code : \(error.code)")
    print("Error Message : \(error.message)")
} catch {
    print("Error")
    print(error.localizedDescription)
}
```

StorjException is further sub-categorized into various error specific classes, These classes inherit all their properties from the base class, i.e. StorjException:

    InternalError
	BandwidthLimitExceededError
	BucketAlreadyExistError
	BucketNameInvalidError
	BucketNotEmptyError
	BucketNotFoundError
	ObjectKeyInvalidError
	ObjectNotFoundError
	TooManyRequestsError
	UploadDoneError
    CancelledError
    InvalidHandleError
    

### InternalError

InternalError is raised when there is issue in resolving request sent to uplink, it might be due to invalid or incorrent parameter passed.

### BandwidthLimitExceededError

BandwidthLimitExceededError is raised when when project will exceeded bandwidth limit.

### BucketAlreadyExistError

BucketAlreadyExistError is raised when the bucket already exists during creation.

### BucketNameInvalidError

BucketNameInvalidError is raised when the bucket name is invalid

### BucketNotEmptyError

BucketNotEmptyError is raised when the bucket is not empty during deletion.

### BucketNotFoundError

BucketNotFoundError is raised when the bucket is not found.

### ObjectKeyInvalidError

ObjectKeyInvalidError is raised when the object key is invalid.

### ObjectNotFoundError

ObjectNotFoundError is raised when the object is not found.

### TooManyRequestsError

TooManyRequestsError is raised when user has sent too many requests in a given amount of time.

### UploadDoneError

UploadDoneError is raised when either Abort or Commit has already been called.

### InvalidHandleError

InvalidHandleError is raised when object handle passes is either invalid or already freed.

## Constants

	ERROR_INTERNAL = 0x02
	ERROR_CANCELED = 0x03
	ERROR_INVALID_HANDLE = 0x04
	ERROR_TOO_MANY_REQUESTS = 0x05
	ERROR_BANDWIDTH_LIMIT_EXCEEDED = 0x06

	ERROR_BUCKET_NAME_INVALID = 0x10
	ERROR_BUCKET_ALREADY_EXISTS = 0x11
	ERROR_BUCKET_NOT_EMPTY = 0x12
	ERROR_BUCKET_NOT_FOUND = 0x13

	ERROR_OBJECT_KEY_INVALID = 0x20
	ERROR_OBJECT_NOT_FOUND = 0x21
	ERROR_UPLOAD_DONE = 0x22


> Note: You can view the libuplink documentation [here](https://godoc.org/storj.io/uplink).