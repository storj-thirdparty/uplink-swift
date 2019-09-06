# swift-storj binding

## Initial Set-up

**NOTE**: For Golang

    Make sure your `PATH` includes the `$GOPATH/bin` directory, so that your commands can be easily used [Refer: Install the Go Tools](https://golang.org/doc/install):
    ```
    export PATH=$PATH:$GOPATH/bin
    ```

    Install [storj-uplink](https://godoc.org/storj.io/storj/lib/uplink) go package, by running:
    ```
    $ go get storj.io/storj/lib/uplink
    ```

**NOTE**:  

    * Please ensure the following software are installed on your system, so as to build the binding from source:
	    1. Xcode


## Set-up Files

* Create Project
    * Open Xcode and go to **File/New/Project**. Find the **macOS** group, select **Application/Command Line Tool** and click **Next**
    * Make sure that **Language** is set to **Swift**, then click **Next**
    
* After git cloning this project, store *libuplinkc_custom.go* file within ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder

* Using cmd/terminal, navigate to the ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder.

* Create '.dylib' file at  ```$HOME/go/src/storj.io/storj/lib/uplinkc``` folder, by using following command:
```
$ go build -v -o libuplinkc.dylib -buildmode=c-shared 
```

* Copy *libuplinkc.dylib, libuplinkc.h, uplink_definitions.h* files into the folder, where Swift project was created

* Add *libuplinkc.dylib, libuplinkc.h, uplink_definitions.h* files to the project:
    * Open the project in Xcode 
    * Select the project in navigation bar by clicking on the project name
    * Click on the File menu
    * Select option to **Add files to "Project Name"...**
    * Navigate to the project location and add the above-mentioned files
    * **NOTE**: After adding the files, check the project's setting through **General > Frameworks and Libraries > Embed**

* Copy *importcfile.c* and *importcfile.h* files into the folder, where Swift project was created

* Add *importcfile.c* and *importcfile.h* files to project:
    * Open project in Xcode
    * Select project in navigation bar by clicking on the project name
    * Click on the File menu
    * Select option **Add files to "Project Name"...** from the File menu
    * Navigate to the project location and add the above-mentioned files 
    * After adding the files to project, the Xcode will ask for *creating a bridging header*
    * Click on create this bridging file
    * Add following code into the bridging-header file:
      * ```#import "importcfile.h"```

* Copy *Uplinkswif.swift* and *main.swift* files into the Project directory's sub-folder, which has the same name as that of the project

* Add files to folder:
    * In Xcode, select the sub-folder, with same name as that of the project, through navigation bar
    * Click on the File menu
    * Select option **Add files to "Project Name"...**
    * Navigate to the project location and add these files

**NOTE with regards to main.swift**:
    * Please give full file name, including absolute file location, which is to be uploaded to Storj, in the "localFullFileNameToUpload" variable
    * In order to write your own code, using the given bindings, please replace the contents of the *main.swift* file
    

## Sample Hello Storj!
The sample *main.swift* code calls the *Uplinkswift.swift* file and binding structure so as to do the following:
    * create a new bucket within desired Storj project
    * write a file from local computer to the created Storj bucket
    * read back the object from the Storj bucket to local PC for verification



## Swift-Storj Binding Functions

**NOTE**: After calling a function, please ensure that the function returned True, before using it further. Please refer the sample *main.swift* file for example.

### newUplink()
    * function to create new Storj uplink
    * pre-requisites: None
    * inputs: None
    * output: True/False

### parseAPIKey(NSString)
    * function to parse API key, to be used by Storj
    * pre-requisites: None
    * inputs: API key (NSString)
    * output: True/False

### openProject(NSString)
    * function to open a Storj project
    * pre-requisites: newUplink() and parseAPIkey() functions have been already called
    * inputs: Satellite Address (NSString)
    * output: True/False

### encryptionKey(NSString)
    * function to get encryption access to upload and download data on Storj
    * pre-requisites: openProject() function has been already called
    * inputs: Encryption Pass Phrase (NSString)
    * output: True/False

### openBucket(NSString)
    * function to open an already existing bucket in Storj project
    * pre-requisites: encryptionKey() function has been already called
    * inputs: Bucket Name (NSString)
    * output: True/False

### upload(NSString, NSString)
    * function to upload data from localFullFileNameToUpload (at local computer) to Storj (V3) bucket's path
    * pre-requisites: openBucket() function has been already called
    * inputs: Storj path/file name (NSString) within the opened bucket, local source full file name (NSString)
    * output: True/False

### download(NSString, NSString)
    * function to download Storj (V3) object's data and store it in given file with localFullFileLocationToStore (on local computer)
    * pre-requisites: openBucket() function has been already called
    * inputs: Storj path/file name (NSString) within the opened bucket, local destination full path name(NSString)
    * output: True/False

### createBucket(NSString)
    * function to create new bucket in Storj project
    * pre-requisites: openProject() function has been already called
    * inputs: Bucket name (NSString)
    * output: True/False

### closeUplink()
    * function to close currently opened uplink
    * pre-requisites: newUplink() function has been already called
    * inputs: none
    * output: True/False

### closeProject()
    * function to close currently opened Storj project
    * pre-requisites: openProject() function has been already called
    * inputs: none
    * output: True/False

### closeBucket()
    * function to close currently opened Bucket
    * pre-requisites: openBucket() function has been already called
    * inputs: none
    * output: True/False
