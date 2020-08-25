## Flow Diagram

![](https://github.com/storj-thirdparty/uplink-swift/blob/master/README.assets/arch.drawio.png)



## Binding Functions

#### `request_Access_With_Passphrase(String, String, String)`

    * function requests satellite for a new access grant using a passhprase
    * pre-requisites: None
    * inputs: Satellite Address, API Key and Encryptionphassphrase 
    * output: AccessResultStr

#### `parse_Access(String)`

    * function to parses serialized access grant string
    * pre-requisites: None
    * inputs: StringKey
    * output: AccessResultStr

#### `config_Request_Access_With_Passphrase(config, String, String, String)`

    * function requests satellite for a new access grant using a passhprase and config.
    * pre-requisites: None
    * inputs: Config ,Satellite Address, API Key and Encryptionphassphrase
    * output: AccessResultStr

#### `serialize()`

    * function to serializes access grant into a string.
    * pre-requisites: None
    * inputs: None
    * output: String


#### `share(UplinkPermission, inout [UplinkSharePrefix])`

    * function creates share access of specified bucket and paths.
    * pre-requisites: config_Request_Access_With_Passphrase or request_Access_With_Passphrase
    * inputs: UplinkPermission and [UplinkSharePrefix]
    * output: AccessResultStr


#### `list_Buckets(inout UplinkListBucketsOptions)`

    * function to lists buckets
    * pre-requisites: open_Project function has been already called
    * inputs: UplinkListBucketsOptions
    * output: [UplinkBucket]

#### `delete_Bucket(bucket:​ String)`

    * function to delete empty bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: UplinkBucket

#### `ensure_Bucket(bucket:​ String)`

    * function to creates a new bucket and ignores the error when it already exists
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: UplinkBucket

#### `create_Bucket(bucket:​ String)`

    * function to create bucket on storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name
    * output: UplinkBucket

#### `stat_Bucket(bucket:​ String)`

    * function returns information about a bucket.
    * pre-requisites: None
    * inputs: Bucket Name 
    * output: UplinkBucket

#### `info()`

    * function returns metadata of downloading object
    * pre-requisites: download_Object function has been already called
    * inputs: None
    * output: UplinkObject

#### `close()`

    * function closes download
    * pre-requisites: download_Object function has been already called
    * inputs: None
    * output: None

#### `read(data:​ UnsafeMutablePointer<UInt8>, sizeToWrite:​ Int)`

    * function reads byte stream from storj V3
    * pre-requisites: download_Object function has been already called
    * inputs: Pointer to array buffer, Size of Buffer
    * output: Int

#### `download_Object(String, String, inout  UplinkDownloadOptions)`

    * function for dowloading object
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name,Object Name on storj V3 and UplinkDownloadOptions
    * output: DownloadResultStr


#### `stat_Object(String, String)`

    * function information about an object at the specific key.
    * pre-requisites: open_project function has been already called
    * inputs: bucket Name and Object
    * output: UplinkObject

#### `delete_Object(String, String)`

    * function delete object from storj V3
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name and Object Name
    * output: UplinkObject

#### `list_Objects(String, ​inout  UplinkListObjectsOptions)`

    * function lists objects
    * pre-requisites: open_Project function has been already called
    * inputs: Bucket Name and UplinkListObjectsOptions
    * output: [UplinkObject]


#### `close_Project()`

    * function close the project.
    * pre-requisites: open_Project function has been already called
    * inputs: None
    * output: None

#### `config_Open_Project(UplinkConfig)`

    * function to open project using access grant and config
    * pre-requisites: request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: Config
    * output: ProjectResultStr

#### `open_Project()`

    * function to open project using access grant.
    * pre-requisites:  request_Access_With_Passphrase or parse_Access function has been already called
    * inputs: None
    * output: ProjectResultStr

#### `info()`

    * function return metadata of uploading object
    * pre-requisites: upload_Object function has been already called
    * inputs: None
    * output: UplinkObject

#### `set_Custom_Metadata(inout UplinkCustomMetadata)`
 
    * function to set custom metadata on storj V3 object
    * pre-requisites: upload_Object function has been already called
    * inputs: UplinkCustomMetadata
    * output: None

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
    * inputs: data:​ UnsafeMutablePointer<UInt8>, sizeToWrite:​ Int
    * output: Int

#### `upload_Object(String, String, ​   inout UplinkUploadOptions)`

    * function to start an upload to the specified key.
    * pre-requisites: open_Project function has been already called
    * inputs: Object name and UplinkUploadOptions
    * output: UploadResultStr



## Testing

* The project has been tested on the following operating system:
```
* macOS Catalina
	* Version: 10.15.4
	* Processor: 2.5 GHz Dual-Core Intel Core i5
```
