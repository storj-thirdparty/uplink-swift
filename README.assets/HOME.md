## Flow Diagram

![](https://github.com/storj-thirdparty/uplink-swift/blob/master/README.assets/arch.drawio.png)



## Binding Functions

#### `request_Access_With_Passphrase(String, String, String)`

    * function requests satellite for a new access grant using a passhprase
    * pre-requisites: None
    * inputs: Satellite Address, API Key and Encryptionphassphrase 
    * output: AccessResult

#### `parse_Access(String)`

    * function to parses serialized access grant string
    * pre-requisites: None
    * inputs: StringKey
    * output: AccessResult

#### `config_request_Access_With_Passphrase(config, String, String, String)`

    * function requests satellite for a new access grant using a passhprase and config.
    * pre-requisites: None
    * inputs: Config ,Satellite Address, API Key and Encryptionphassphrase
    * output: AccessResult

#### `derive_Encryption_Key(String, [UInt8])`

    * function derives a salted encryption key for passphrase using the salt.
    * pre-requisites: None
    * inputs: Passphrase and Array
    * output: UplinkEnc

#### `serialize()`

    * function to serializes access grant into a string.
    * pre-requisites: None
    * inputs: None
    * output: StringResult


#### `access_Share(Permission, SharePrefix, Int)`

    * function creates share access of specified bucket and paths.
    * pre-requisites: config_Request_Access_With_Passphrase or config_Request_Access_With_Passphrase
    * inputs: Permission ,UnsafeMutablePointer<[SharePrefix]>,Int
    * output: AccessResult

#### `list_Buckets(inout ListBucketsOptions)`

    * function to lists buckets
    * pre-requisites: open_Project function has been already called
    * inputs: List Bucket Options
    * output: None

#### `delete_Bucket(String)`

    * function to delete empty bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: BucketResult

#### `ensure_Bucket(String)`

    * function to creates a new bucket and ignores the error when it already exists
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: BucketResult

#### `create_Bucket(String)`

    * function to create bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: BucketResult

#### `stat_Bucket(String)`

    * function returns information about a bucket.
    * pre-requisites: None
    * inputs: Bucket Name 
    * output: BucketResult


#### `info()`

    * function returns metadata of downloading object
    * pre-requisites: download_Object function has been already called
    * inputs: None
    * output: ObjectResult

#### `close()`

    * function closes download
    * pre-requisites: download_Object function has been already called
    * inputs: None
    * output: None

#### `read(UnsafeMutablePointer<UInt8>, Int)`

    * function reads byte stream from storj V3
    * pre-requisites: download_Object function has been already called
    * inputs: Pointer to array buffer, Size of Buffer
    * output: ReadResult

#### `download_Object(String, String, DownloadOptions)`

    * function for dowloading object
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project> ,Object Name on storj V3 and UnsafeMutablePointer<DownloadOptions>
    * output: DownloadResult

#### `stat_Object(String, String)`

    * function information about an object at the specific key.
    * pre-requisites: open_project function has been already called
    * inputs: Bucket Name and Object Name
    * output: ObjectResult

#### `delete_Object(String, String)`

    * function delete object from storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name and Object Name
    * output: ObjectResult

#### `list_Objects(String, ListObjectsOptions)`

    * function lists objects
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name and ListObjectsOptions
    * output: UnsafeMutablePointer<ObjectIterator>? or nil

#### `close_Project()`

    * function close the project.
    * pre-requisites: open_Project function has been already called
    * inputs: UnsafeMutablePointer<Project>
    * output: UnsafeMutablePointer<Error>? or nil

#### `config_Open_Project(Config)`

    * function to open project using access grant and config
    * pre-requisites: request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: Config
    * output: ProjectResult

#### `open_Project()`

    * function to open project using access grant.
    * pre-requisites:  request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: None
    * output: ProjectResult

#### `info()`

    * function return metadata of uploading object
    * pre-requisites: upload_Object function has been already called
    * inputs: None
    * output: ObjectResult

#### `set_Custom_Metadata(CustomMetadata)`

    * function to set custom metadata on storj V3 object
    * pre-requisites: upload_Object function has been already called
    * inputs: CustomMetadata
    * output: UnsafeMutablePointer<Error>? or nil

#### `abort()`

    * function to abort current upload
    * pre-requisites: upload_Object function has been already called
    * inputs: None
    * output: None

#### `commit()`

    * function to commits the uploaded data.
    * pre-requisites: upload_Object function has been already called
    * inputs: None
    * output: None

#### `write(UnsafeMutablePointer<UInt8>, Int)`

    * function to upload len(p) bytes from p to the object's data stream.
    * pre-requisites: upload_Object function has been already called
    * inputs: Pointer to buffer array , Len of buffer
    * output: WriteResult

#### `upload_Object(String, UploadOptions)`

    * function to start an upload to the specified key.
    * pre-requisites: open_Project function has been already called
    * inputs: Object name and UploadOptions
    * output: UploadResult

#### `access_Override_Encryption_Key(String,String,UplinkEncryptionKeyResult)`

    * function to start an upload to the specified key.
    * pre-requisites: open_Project function has been already called
    * inputs: Object name and UploadOptions
    * output: UploadResult

## Testing

* The project has been tested on the following operating system:
```
* macOS Catalina
	* Version: 10.15.4
	* Processor: 2.5 GHz Dual-Core Intel Core i5
```
