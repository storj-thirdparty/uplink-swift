## Flow Diagram

![](https://github.com/storj-thirdparty/uplink-swift/blob/master/README.assets/arch.drawio.png)



## Binding Functions

#### `request_Access_With_Passphrase(NSString, NSString, NSString)`

    * function requests satellite for a new access grant using a passhprase
    * pre-requisites: None
    * inputs: Satellite Address, API Key and Encryptionphassphrase 
    * output: AccessResult

#### `parse_Access(NSString)`

    * function to parses serialized access grant string
    * pre-requisites: None
    * inputs: StringKey
    * output: AccessResult

#### `config_Request_Access_With_Passphrase(config, NSString, NSString, NSString)`

    * function requests satellite for a new access grant using a passhprase and config.
    * pre-requisites: None
    * inputs: Config ,Satellite Address, API Key and Encryptionphassphrase
    * output: AccessResult

#### `access_Serialize(inout Access)`

    * function to serializes access grant into a string.
    * pre-requisites: None
    * inputs: Access
    * output: StringResult

#### `free_Access_Result(inout AccessResult)`

    * function frees memory associated with the AccessResult.
    * pre-requisites: None
    * inputs: AccessResult
    * output: None

#### `access_Share(inout UnsafeMutablePointer<AccessResult>, inout Permission, inout UnsafeMutablePointer<SharePrefix>, Int)`

    * function creates share access of specified bucket and paths.
    * pre-requisites: config_Request_Access_With_Passphrase or config_Request_Access_With_Passphrase
    * inputs: UnsafeMutablePointer<AccessResult>,Permission ,UnsafeMutablePointer<[SharePrefix]>,Int
    * output: AccessResult

#### `free_String_Result(inout StringResult)`

    * function to free memory associated with the StringResult
    * pre-requisites: None
    * inputs: StringResult
    * output: None

#### `free_Bucket_Result(inout BucketResult)`

    * function frees memory associated with the BucketResult.
    * pre-requisites: None
    * inputs: BucketResult
    * output: None

#### `free_Bucket(inout UnsafeMutablePointer<Bucket>)`

    * function frees memory associated with the Bucket.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<Bucket>
    * output: None

#### `free_Bucket_Iterator(inout UnsafeMutablePointer<BucketIterator>)`

    * function frees memory associated with the BucketIterator.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<BucketIterator>
    * output: None

#### `bucket_Iterator_Err(inout UnsafeMutablePointer<BucketIterator>)`

    * function bucket_iterator_err returns error, if one happened during iteration.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<BucketIterator>
    * output: UnsafeMutablePointer<Error>? or nil

#### `bucket_Iterator_Item(inout UnsafeMutablePointer<BucketIterator>)`

    * function to returns the current bucket in the iterator.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<BucketIterator>
    * output: UnsafeMutablePointer<Bucket>? or nil

#### `bucket_Iterator_Next(inout UnsafeMutablePointer<BucketIterator>)`

    * function prepares next Bucket for reading.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<BucketIterator>
    * output: Bool

#### `list_Buckets(inout UnsafeMutablePointer<Project>, inout ListBucketsOptions)`

    * function to lists buckets
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> and List Bucket Options
    * output: UnsafeMutablePointer<BucketIterator>? or nil

#### `delete_Bucket(inout UnsafeMutablePointer<Project>, NSString)`

    * function to delete empty bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> and Bucket Name
    * output: BucketResult

#### `ensure_Bucket(inout UnsafeMutablePointer<Project>, NSString)`

    * function to creates a new bucket and ignores the error when it already exists
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> and Bucket Name
    * output: BucketResult

#### `create_Bucket(inout UnsafeMutablePointer<Project>, NSString)`

    * function to create bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> and Bucket Name
    * output: BucketResult

#### `stat_Bucket(inout UnsafeMutablePointer<Project>, NSString)`

    * function returns information about a bucket.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<Project> and Bucket Name 
    * output: BucketResult

#### `free_Download_Result(inout DownloadResult)`

    * function frees memory associated with the DownloadResult.
    * pre-requisites: None
    * inputs: DownloadResult
    * output: None

#### `free_Read_Result(inout ReadResult)`

    * function frees memory associated with the ReadResult.
    * pre-requisites: None
    * inputs: ReadResult
    * output: None

#### `download_Info(inout UnsafeMutablePointer<Download>)`

    * function returns metadata of downloading object
    * pre-requisites: download_Object function has been already called
    * inputs: UnsafeMutablePointer<Download>
    * output: ObjectResult

#### `close_Download(inout UnsafeMutablePointer<Download>)`

    * function closes download
    * pre-requisites: download_Object function has been already called
    * inputs: UnsafeMutablePointer<Download>
    * output: UnsafeMutablePointer<Error>? or nil

#### `download_Read(inout UnsafeMutablePointer<Download>, UnsafeMutablePointer<UInt8>, Int)`

    * function reads byte stream from storj V3
    * pre-requisites: download_Object function has been already called
    * inputs: UnsafeMutablePointer<Download> ,Pointer to array buffer, Size of Buffer
    * output: ReadResult

#### `download_Object(inout UnsafeMutablePointer<Project>, NSString, NSString, UnsafeMutablePointer<DownloadOptions>)`

    * function for dowloading object
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> ,Object Name on storj V3 and UnsafeMutablePointer<DownloadOptions>
    * output: DownloadResult

#### `free_Error(inout UnsafeMutablePointer<Error>)`

    * function frees memory associated with the Error.
    * pre-requisites: None
    * inputs: inout UnsafeMutablePointer<Error>
    * output: None

#### `free_Object(inout UnsafeMutablePointer<Object>)`

    * function frees memory associated with the Object.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<Object>
    * output: None

#### `free_Object_Result(inout ObjectResult)`

    * function frees memory associated with the ObjectResult.
    * pre-requisites: None
    * inputs: ObjectResult
    * output: None

#### `free_Object_Iterator(inout UnsafeMutablePointer<ObjectIterator>)`

    * function frees memory associated with the ObjectIterator.
    * pre-requisites: None
    * inputs: UnsafeMutablePointer<ObjectIterator>
    * output: None

#### `stat_Object(inout UnsafeMutablePointer<Project>, NSString,NSString)`

    * function information about an object at the specific key.
    * pre-requisites: open_project function has been already called
    * inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
    * output: ObjectResult

#### `delete_Object(inout UnsafeMutablePointer<Project>, NSString, NSString)`

    * function delete object from storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> , Bucket Name and Object Name
    * output: ObjectResult

#### `object_Iterator_Err(inout UnsafeMutablePointer<ObjectIterator>)`

    * function returns error, if one happened during iteration.
    * pre-requisites: list_Objects function has been already called
    * inputs: UnsafeMutablePointer<ObjectIterator>
    * output: UnsafeMutablePointer<Error>? or nil

#### `object_Iterator_Item(inout UnsafeMutablePointer<ObjectIterator>)`

    * function returns the current object in the iterator.
    * pre-requisites: list_Objects function has been already called
    * inputs: UnsafeMutablePointer<ObjectIterator>
    * output: UnsafeMutablePointer<Object>? or nil

#### `object_Iterator_Next(inout UnsafeMutablePointer<ObjectIterator>)`

    * function prepares next Object for reading.
    * pre-requisites: list_Objects function has been already called
    * inputs: UnsafeMutablePointer<ObjectIterator>
    * output: Bool

#### `list_Objects(inout UnsafeMutablePointer, NSString, inout ListObjectsOptions)`

    * function lists objects
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> ,Bucket Name and ListObjectsOptions
    * output: UnsafeMutablePointer<ObjectIterator>? or nil

#### `free_Project_Result(inout ProjectResult)`

    * function frees memory associated with the ProjectResult.
    * pre-requisites: None
    * inputs: ProjectResult
    * output: None

#### `close_Project(inout UnsafeMutablePointer<Project>)`

    * function close the project.
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project>
    * output: UnsafeMutablePointer<Error>? or nil

#### `config_Open_Project(Config, inout UnsafeMutablePointer)`

    * function to open project using access grant and config
    * pre-requisites: request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: Config and UnsafeMutablePointer<Access>
    * output: ProjectResult

#### `open_Project(inout UnsafeMutablePointer<Access>)`

    * function to open project using access grant.
    * pre-requisites:  request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: UnsafeMutablePointer<Access>
    * output: ProjectResult

#### `free_Upload_Result(inout UploadResult)`

    * function frees memory associated with the UploadResult.
    * pre-requisites: None
    * inputs: UploadResult
    * output: None

#### `free_Write_Result(inout WriteResult)`

    * function frees memory associated with the WriteResult.
    * pre-requisites: None
    * inputs: WriteResult
    * output: None

#### `upload_Info(inout UnsafeMutablePointer<Upload>)`

    * function return metadata of uploading object
    * pre-requisites: upload_Object function has been already called
    * inputs: UnsafeMutablePointer<Upload>
    * output: ObjectResult

#### `upload_Set_Custom_Metadata(inout UnsafeMutablePointer<Upload>, CustomMetadata)`

    * function to set custom metadata on storj V3 object
    * pre-requisites: upload_Object function has been already called
    * inputs: UnsafeMutablePointer<Upload> ,CustomMetadata
    * output: UnsafeMutablePointer<Error>? or nil

#### `upload_Abort(inout UnsafeMutablePointer<Upload>)`

    * function to abort current upload
    * pre-requisites: upload_Object function has been already called
    * inputs: UnsafeMutablePointer<Upload>
    * output: UnsafeMutablePointer<Error>? or nil

#### `upload_Commit(inout UnsafeMutablePointer<Upload>)`

    * function to commits the uploaded data.
    * pre-requisites: upload_Object function has been already called
    * inputs: UnsafeMutablePointer<Upload>
    * output: UnsafeMutablePointer<Error>? or nil

#### `upload_Write(inout UnsafeMutablePointer<Upload>, UnsafeMutablePointer<UInt8>, Int)`

    * function to upload len(p) bytes from p to the object's data stream.
    * pre-requisites: upload_Object function has been already called
    * inputs: UnsafeMutablePointer<Upload> ,Pointer to buffer array , Len of buffer
    * output: WriteResult

#### `upload_Object(inout UnsafeMutablePointer<Project>, NSString, UnsafeMutablePointer<UploadOptions>)`

    * function to start an upload to the specified key.
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project>, Object name and UnsafeMutablePointer<UploadOptions>
    * output: UploadResult



## Testing

* The project has been tested on the following operating system:
```
* macOS Catalina
	* Version: 10.15.4
	* Processor: 2.5 GHz Dual-Core Intel Core i5
	* Node version : 13.6.0
```
