# storj-swift binding

## Initial Set-up

**NOTE**: for Golang

Make sure your `PATH` includes the `$GOPATH/bin` directory, so that your commands can be easily used [Refer: Install the Go Tools](https://golang.org/doc/install):
```
export PATH=$PATH:$GOPATH/bin
```

Install [storj-uplink](https://godoc.org/storj.io/storj/lib/uplink) go package, by running:
```
$ go get storj.io/storj/lib/uplink
```

In case, following errors get reported during the process:
```
go/src/github.com/zeebo/errs/errs.go:42:9: undefined: errors.Unwrap
go/src/github.com/zeebo/errs/group.go:84:6: undefined: errors.Is
```
please arrange for the module dependencies to be met, using the Go modules functionality.
Reference: [ISSUE#3053: Getting error while downloading module](https://github.com/storj/storj/issues/3053#issuecomment-532883993)


**NOTE**: for Swift

* Please ensure that the Xcode software is installed on your system, so as to build the binding from source.
* [Add the `storj-swift` package to your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)


## Set-up Files

* Create '.dylib' file at  ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder, by using following command:
```
$ go build -v -o libuplinkc.dylib -buildmode=c-shared 
```

* Copy *libuplinkc.dylib* file into the `storj-swift/Sources/Clibuplink/include` folder of the package


## Sample Hello Storj!
The sample *main.swift* code in `storj-swift/Sources/helloStorj` folder calls the *storj_swift.swift* file, so as to do the following:
* create a new bucket (if it does not exist) desired Storj project
* lists all bucket in a Storj project
* write a file from local system to the created/opened Storj bucket
* read back the object from the Storj bucket to local system, for verification
* list all object in a bucket
* delete object from a bucket
* delete empty bucket from a Storj project


## Swift-Storj Binding Functions

**NOTE**: After calling a function, please ensure that the function returned an empty error string, before using it further. Please refer the sample *main.swift* file for example.

### newUplink()
    * function to create new Storj uplink
    * pre-requisites: None
    * inputs: None
    * output: Uplink and error (string)

### closeUplink(Uplink)
    * function to close currently open uplink
    * pre-requisites: newUplink() function has been already called
    * inputs: Uplink
    * output: error (NSString)

### parseAPIKey(NSString)
    * function to parse API key, to be used by Storj
    * pre-requisites: None
    * inputs: API key (NSString)
    * output: APIKey and error (string)

### openProject(Uplink, NSString, APIKey)
    * function to open a Storj project
    * pre-requisites: newUplink() and parseAPIkey() functions have been already called
    * inputs: Uplink, Satellite Address (NSString) and APIKey
    * output: Project and error (string)

### closeProject(Project)
    * function to close currently open Storj project
    * pre-requisites: openProject() function has been already called
    * inputs: Project
    * output: error (NSString)

### createBucket(Project, NSString)
    * function to create a new bucket in Storj project
    * pre-requisites: openProject() function has been already called
    * inputs: Project, Bucket name (NSString)
    * output: BucketInfo, error (NSString)

### getEncryptionAccess(Project, NSString)
    * function to get encryption access to upload and download data on Storj
    * pre-requisites: openProject() function has been already called
    * inputs: Project, Encryption Pass Phrase (NSString)
    * output: SaltedKeyFromPassphrase (UnsafeMutablePointer<Int8>?), error (NSString)

### openBucket(Project, NSString, SaltedKeyFromPassphrase)
    * function to open an already existing bucket in Storj project
    * pre-requisites: getEncryptionAccess() function has been already called
    * inputs: Project, Bucket Name (NSString) and SaltedKeyFromPassphrase (UnsafeMutablePointer<Int8>?)
    * output: Bucket, error (NSString)

### listBuckets(Project, &BucketListOptions)
    * function to list all the buckets in a Storj project
    * pre-requeisites: openProject() function has been already called
    * inputs: Project, address of BucketListOptions
    * output: BucketList and error (string)

### freeBucketList(UnsafeMutablePointer<BucketList>)
    * function to free Bucket list
    * pre-requeisites: listBucket() function has been already called
    * inputs: Pointer to BucketList (UnsafeMutablepointer<BucketList>)
    * output: error (NSString)

### closeBucket(Bucket)
    * function to close currently open Bucket
    * pre-requisites: openBucket() function has been already called
    * inputs: Bucket
    * output: error (NSString)

### deleteBucket(Project, NSString)
    * function to delete a empty bucket
    * pre-requeisites: openBucket() function has been already called
    * inputs: Project, Storj Bucket Name (NSString)
    * output: BucketList and error (NSString)

### listObjects(Bucket, &ListOptions)
    * function to list object in desired bucket
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, address of ListOptions
    * output: ObjectList and error (NSString)

### deleteObject(Bucket, NSString)
    * function to delete an object in a bucket
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, Storj Path/File Name (NSString)
    * output: BucketList and error (NSString)

### freeObjectList(UnsafeMutablePointer<ObjectList>)
    * function to free ObjectList
    * pre-requeisites: listObject() function has been already called
    * inputs: Pointer to ObjectList (UnsafeMutablepointer<ObjectList>)
    * output: error (NSString)
    
### upload(Bucket, NSString,  NSString, UnsafeMutablePointer<UploadOptions>)
    * function to get uploader handle used to upload data to Storj (V3) bucket's path
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Source Full File Name (NSString)
    * output: Uploder and error (NSString)

### UploadWrite(Uploader, UnsafeMutablePointer<UInt8>, Int)
    * function to write data to Storj (V3) bucket's path
    * pre-requeisites: Upload() function has been already called
    * inputs: Uploader, Pointer to bytes array (UnsafeMutablepointer<UInt8>) , sizeofbytesarray(Int)
    * output: Size of data uploaded (Int) and error (NSString)

### UploadCommit(Uploader)
    * function to commit and finalize file for uploaded data to Storj (V3) bucket's path
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Full File Name (NSString)
    * output: Downloader , error (NSString)

### Download(Bucket, NSString)
    * function to get downloader handle to download Storj (V3) object's data and store it on local computer
    * pre-requeisites: openBucket() function has been already called
    * inputs: Bucket, Storj Path/File Name (NSString) within opened bucket, local Full File Name (NSString)
    * output: Downloader , error (NSString)

### downloadRead(Downloader, UnsafeMutablePointer<UInt8>, Int)
    * function to read Storj (V3) object's data and return the data
    * pre-requeisites: Download() function has been already called
    * inputs: Downloader, Pointer to bytes array (UnsafeMutablepointer<UInt8>) , sizeofbytesarray(Int)
    * output: Size of downloaded data (Int) , error (NSString)

### downloadClose(Downloader)
    * function to close downloader after completing the data read process
    * pre-requeisites: Download() function has been already called
    * inputs: Downloader
    * output: error (NSString)
    
