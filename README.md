# <b>uplink-swift binding</b>

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2a62886560a64453b2d5417393b2305f)](https://app.codacy.com/gh/storj-thirdparty/uplink-swift?utm_source=github.com&utm_medium=referral&utm_content=storj-thirdparty/uplink-swift&utm_campaign=Badge_Grade_Dashboard)

#### *Developed using v1.2.2 storj/uplink-c*

[API documentation and tutorial](https://storj-thirdparty.github.io/uplink-swift/#/)

## <b>Initial Set-up (Important)</b>

>NOTE: For Golang

Make sure your `PATH` includes the `$GOPATH/bin` directory, so that your commands can be easily used [Refer: Install the Go Tools](https://golang.org/doc/install):
```
export PATH=$PATH:$GOPATH/bin
```

## <b>Set-up Files</b>

Add Swift Module in Swift Project
* Open Xcode
* Click on File > Swift Packages > Add Package Dependency
* In New Pop Up window paste [uplink-swift](https://github.com/storj-thirdparty/uplink-swift.git) repository link and Click on next
* Select branch name or version of package and then click on next button.
* Uncheck the checkbox of uplink-swift library and then, click on finish button.
* Using terminal navigate to the location of the uplink-swift library added in project.
* Run following command in the terminal
```
	make
```
* In Xcode, General > Frameworks and Libraries Section
* Click on + icon and select storj-swift then click on Add button
>NOTE: Storj("") if required then pass location of libuplinkc.dylib. Please refer sample *main.swift* file for sample.


## <b>Documentation</b>
For more information on function definations and diagrams, check out the [Detail](//github.com/storj-thirdparty/uplink-swift/wiki/Home) or jump to:
* [Uplink-swift Binding Functions](//github.com/storj-thirdparty/uplink-swift/wiki/#binding-functions)
* [Flow Diagram](//github.com/storj-thirdparty/uplink-swift/wiki/#flow-diagram)
* [libuplink Documentation](https://godoc.org/storj.io/uplink)
* [Testing](//github.com/storj-thirdparty/uplink-swift/wiki/#testing)
