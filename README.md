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

**NOTE**: Please ensure that the Xcode software is installed on your system, so as to build the binding from source.


## Set-up Files

* Create Project
    * Open Xcode and go to **File/New/Project**. Find the **macOS** group, select **Application/Command Line Tool** and click **Next**
    * Make sure that **Language** is set to **Swift**, then click **Next**
    
* Create Library in Swift Project
    * In Xcode, again go to **File/New/Project**. Find the **macOS** group, select **Library** from Framework & Library section and click **Next**
    * Enter a library name, *say*, "storj" and click **Next**
    * Select a project name from **Add to** field and click on **Create**

* Add Library in Swift Project
    * **General > Frameworks and Libraries Section**
    * Click on **+** icon and then search for name "lib" + library name created + ".dylib"
    * Select .dylib file and click on **Add**
    * **NOTE**: After adding the files, check the project's setting through **General > Frameworks and Libraries > Embed**

* Using cmd/terminal, navigate to the ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder.

* Create '.dylib' file at  ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder, by using following command:
```
$ go build -v -o libuplinkc.dylib -buildmode=c-shared 
```

* Copy *libuplinkc.dylib, libuplinkc.h, uplink_definitions.h, and Uplink.swift* files into the library's sub directory, that either has the same name as that of the library OR contains .h and .m files

* Add *libuplinkc.dylib, libuplinkc.h, and uplink_definitions.h* files to the library's sub-directory, that has the same name as that of the library:
    * Open the project in Xcode 
    * Select the afore-mentioned sub directory in navigation bar by clicking on its name
    * Click on the File menu
    * Select option to **Add files to "Library Name"...**
    * Navigate to the library location and add the above-mentioned files

* Add *Uplink.swift* files to library:
    * Open the project in Xcode
    * Select folder name, same as library name, in the navigation bar by clicking on it
    * Click on the File menu
    * Select option **Add files to "Library Name"...** from the File menu
    * Navigate to the library folder and add the above-mentioned file
    * After adding the files to library, the Xcode will ask for *creating a bridging header*
    * Click on create this bridging file
    * Add following code in the bridging-header file:
      * ```#import "libuplinkc.h"```
    * Delete .h and .m files. with the same name as that of the library, from the library folder

* Copy *main.swift* file into the project directory's sub-folder, which has the same name as that of the project

* Add files to folder:
    * In Xcode, select the sub-folder, with same name as that of the project, through navigation bar
    * Click on the File menu
    * Select option **Add files to "Project Name"...**
    * Navigate to the project location and add these file

**NOTE with regards to main.swift**:
* Please give full file name, including absolute file location, which is to be uploaded to Storj, in the "localFullFileNameToUpload" variable
* In order to write your own code, using the given bindings, please replace the contents of the *main.swift* file
* Use import command to import the above library into your main file.


## Sample Hello Storj!
The sample *main.swift* code calls the *UplinkSwift.swift* file and binding structure so as to do the following:
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
    