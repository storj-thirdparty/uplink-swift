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
* create a new bucket within desired Storj project
* write a file from local system to the created/opened Storj bucket
* read back the object from the Storj bucket to local system, for verification


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
    * function to create new bucket in Storj project
    * pre-requisites: openProject() function has been already called
    * inputs: Project, Bucket name (NSString)
    * output: BucketInfo, error (NSString)

### getEncryptionAccess(Project, NSString)
    * function to get encryption access to upload and/or download data to/from Storj bucket
    * pre-requisites: openProject() function has been already called
    * inputs: Project, Encryption Pass Phrase (NSString)
    * output: Serialized Encryption Access (UnsafeMutablePointer<Int8>?), error (NSString)

### openBucket(Project, NSString, SerializedEncryptionAccess)
    * function to open an already existing bucket in Storj project
    * pre-requisites: getEncryptionAccess() function has been already called
    * inputs: Project, Bucket Name (NSString) and Serialized Encryption Access (UnsafeMutablePointer<Int8>?)
    * output: Bucket, error (NSString)

### closeBucket(Bucket)
    * function to close currently open Bucket
    * pre-requisites: openBucket() function has been already called
    * inputs: Bucket
    * output: error (NSString)

### uploadFile(Bucket, NSString, NSString)
    * function to upload data from localFullFileNameToUpload (at local system) to Storj (V3) bucket's path
    * pre-requisites: openBucket() function has been already called
    * inputs: Bucket, Storj path/file name (NSString) within the opened bucket, local source full file name (NSString)
    * output: error (NSString)

### downloadFile(Bucket, NSString, NSString)
    * function to download Storj (V3) object's data and store it in given file with localFullFileLocationToStore (at local system)
    * pre-requisites: openBucket() function has been already called
    * inputs: Bucket, Storj path/file name (NSString) within the opened bucket, local destination full path name(NSString)
    * output: error (NSString)
