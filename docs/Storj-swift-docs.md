# Storj

``` swift
public struct Storj
```

## Initializers

### `init(_:)`

``` swift
public init(_ userLiblocation: String)
```

## Properties

### `dynamicFileLocation`

``` swift
var dynamicFileLocation: String
```

## Methods

### `request_Access_With_Passphrase(satelliteAddress:apiKey:encryptionPassphrase:)`

``` swift
mutating public func request_Access_With_Passphrase(satelliteAddress: NSString, apiKey: NSString, encryptionPassphrase: NSString) throws -> (AccessResult)
```

### `config_Request_Access_With_Passphrase(config:satelliteAddress:apiKey:encryptionPassphrase:)`

``` swift
mutating public func config_Request_Access_With_Passphrase(config: Config, satelliteAddress: NSString, apiKey: NSString, encryptionPassphrase: NSString) throws -> (AccessResult)
```

### `parse_Access(stringKey:)`

``` swift
mutating public func parse_Access(stringKey: NSString) throws -> (AccessResult)
```

### `access_Serialize(access:)`

``` swift
mutating public func access_Serialize(access: inout Access) throws -> (StringResult)
```

### `free_String_Result(stringResult:)`

``` swift
mutating public func free_String_Result(stringResult: inout StringResult) throws -> ()
```

### `stat_Bucket(project:bucketName:)`

``` swift
mutating public func stat_Bucket(project: inout UnsafeMutablePointer<Project>, bucketName: NSString) throws -> (BucketResult)
```

### `create_Bucket(project:bucketName:)`

``` swift
mutating public func create_Bucket(project: inout UnsafeMutablePointer<Project>, bucketName: NSString) throws -> (BucketResult)
```

### `ensure_Bucket(project:bucketName:)`

``` swift
mutating public func ensure_Bucket(project: inout UnsafeMutablePointer<Project>, bucketName: NSString) throws -> (BucketResult)
```

### `delete_Bucket(project:bucketName:)`

``` swift
mutating public func delete_Bucket(project: inout UnsafeMutablePointer<Project>, bucketName: NSString) throws -> (BucketResult)
```

### `list_Buckets(project:listBucketsOptionsObj:)`

``` swift
mutating public func list_Buckets(project: inout UnsafeMutablePointer<Project>, listBucketsOptionsObj: inout ListBucketsOptions) throws -> (UnsafeMutablePointer<BucketIterator>?)
```

### `bucket_Iterator_Next(bucketIterator:)`

``` swift
mutating public func bucket_Iterator_Next(bucketIterator: inout UnsafeMutablePointer<BucketIterator>) throws -> (Bool)
```

### `bucket_Iterator_Item(bucketIterator:)`

``` swift
mutating public func bucket_Iterator_Item(bucketIterator: inout UnsafeMutablePointer<BucketIterator>) throws -> (UnsafeMutablePointer<Bucket>?)
```

### `bucket_Iterator_Err(bucketIterator:)`

``` swift
mutating public func bucket_Iterator_Err(bucketIterator: inout UnsafeMutablePointer<BucketIterator>) throws -> (UnsafeMutablePointer<Error>?)
```

### `open_Project(access:)`

``` swift
mutating public func open_Project(access: inout UnsafeMutablePointer<Access>) throws -> (ProjectResult)
```

### `config_Open_Project(config:access:)`

``` swift
mutating public func config_Open_Project(config: Config, access: inout UnsafeMutablePointer<Access>) throws -> (ProjectResult)
```

### `close_Project(project:)`

``` swift
mutating public func close_Project(project: inout UnsafeMutablePointer<Project>) throws -> (UnsafeMutablePointer<Error>?)
```

### `upload_Object(project:storjBucketName:storjUploadPath:uploadOptions:)`

``` swift
mutating public func upload_Object(project: inout UnsafeMutablePointer<Project>, storjBucketName: NSString, storjUploadPath: NSString, uploadOptions: UnsafeMutablePointer<UploadOptions>) throws -> (UploadResult)
```

### `upload_Write(upload:data:sizeToWrite:)`

``` swift
mutating public func upload_Write(upload: inout UnsafeMutablePointer<Upload>, data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int) throws -> (WriteResult)
```

### `upload_Commit(upload:)`

``` swift
mutating public func upload_Commit(upload: inout UnsafeMutablePointer<Upload>) throws -> (UnsafeMutablePointer<Error>?)
```

### `upload_Abort(upload:)`

``` swift
mutating public func upload_Abort(upload: inout UnsafeMutablePointer<Upload>) throws -> (UnsafeMutablePointer<Error>?)
```

### `upload_Set_Custom_Metadata(upload:customMetaDataObj:)`

``` swift
mutating public func upload_Set_Custom_Metadata(upload: inout UnsafeMutablePointer<Upload>, customMetaDataObj: CustomMetadata) throws -> (UnsafeMutablePointer<Error>?)
```

### `download_Object(project:storjBucketName:storjObjectName:downloadOptions:)`

``` swift
mutating public func download_Object(project: inout UnsafeMutablePointer<Project>, storjBucketName: NSString, storjObjectName: NSString, downloadOptions: UnsafeMutablePointer<DownloadOptions>) throws -> (DownloadResult)
```

### `download_Read(download:data:sizeToWrite:)`

``` swift
mutating public func download_Read(download: inout UnsafeMutablePointer<Download>, data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int) throws -> (ReadResult)
```

### `close_Download(download:)`

``` swift
mutating public func close_Download(download: inout UnsafeMutablePointer<Download>) throws -> (UnsafeMutablePointer<Error>?)
```

### `download_Info(download:)`

``` swift
mutating public func download_Info(download: inout UnsafeMutablePointer<Download>) throws -> (ObjectResult)
```

### `upload_Info(upload:)`

``` swift
mutating public func upload_Info(upload: inout UnsafeMutablePointer<Upload>) throws -> (ObjectResult)
```

### `list_Objects(project:storjBucketName:listObjectsOptions:)`

``` swift
mutating public func list_Objects(project: inout UnsafeMutablePointer<Project>, storjBucketName: NSString, listObjectsOptions: inout ListObjectsOptions) throws -> (UnsafeMutablePointer<ObjectIterator>?)
```

### `object_Iterator_Next(objectIterator:)`

``` swift
mutating public func object_Iterator_Next(objectIterator: inout UnsafeMutablePointer<ObjectIterator>) throws -> (Bool)
```

### `object_Iterator_Item(objectIterator:)`

``` swift
mutating public func object_Iterator_Item(objectIterator: inout UnsafeMutablePointer<ObjectIterator>) throws -> (UnsafeMutablePointer<Object>?)
```

### `object_Iterator_Err(objectIterator:)`

``` swift
mutating public func object_Iterator_Err(objectIterator: inout UnsafeMutablePointer<ObjectIterator>) throws -> (UnsafeMutablePointer<Error>?)
```

### `delete_Object(project:bucketName:storjObjectName:)`

``` swift
mutating public func delete_Object(project: inout UnsafeMutablePointer<Project>, bucketName: NSString, storjObjectName: NSString) throws -> (ObjectResult)
```

### `stat_Object(project:bucketName:storjObjectName:)`

``` swift
mutating public func stat_Object(project: inout UnsafeMutablePointer<Project>, bucketName: NSString, storjObjectName: NSString) throws -> (ObjectResult)
```

### `access_Share(access:permission:prefix:prefixCount:)`

``` swift
mutating public func access_Share(access: inout UnsafeMutablePointer<Access>, permission: inout Permission, prefix: inout UnsafeMutablePointer<SharePrefix>, prefixCount: Int) throws -> (AccessResult)
```

### `free_Bucket_Iterator(bucketIterator:)`

``` swift
mutating public func free_Bucket_Iterator(bucketIterator: inout UnsafeMutablePointer<BucketIterator>) throws -> ()
```

### `free_Bucket(bucket:)`

``` swift
mutating public func free_Bucket(bucket: inout UnsafeMutablePointer<Bucket>) throws -> ()
```

### `free_Object_Iterator(objectIterator:)`

``` swift
mutating public func free_Object_Iterator(objectIterator: inout UnsafeMutablePointer<ObjectIterator>) throws -> ()
```

### `free_Read_Result(readResult:)`

``` swift
mutating public func free_Read_Result(readResult: inout ReadResult) throws -> ()
```

### `free_Download_Result(downloadResult:)`

``` swift
mutating public func free_Download_Result(downloadResult: inout DownloadResult) throws -> ()
```

### `free_Bucket_Result(bucketResult:)`

``` swift
mutating public func free_Bucket_Result(bucketResult: inout BucketResult) throws -> ()
```

### `free_Error(error:)`

``` swift
mutating public func free_Error(error: inout UnsafeMutablePointer<Error>) throws -> ()
```

### `free_Object_Result(objectResult:)`

``` swift
mutating public func free_Object_Result(objectResult: inout ObjectResult) throws -> ()
```

### `free_Object(object:)`

``` swift
mutating public func free_Object(object: inout UnsafeMutablePointer<Object>) throws -> ()
```

### `free_Project_Result(projectResult:)`

``` swift
mutating public func free_Project_Result(projectResult: inout ProjectResult) throws -> ()
```

### `free_Write_Result(writeResult:)`

``` swift
mutating public func free_Write_Result(writeResult: inout WriteResult) throws -> ()
```

### `free_Upload_Result(uploadResult:)`

``` swift
mutating public func free_Upload_Result(uploadResult: inout UploadResult) throws -> ()
```

### `free_Access_Result(accessResult:)`

``` swift
mutating public func free_Access_Result(accessResult: inout AccessResult) throws -> ()
```
