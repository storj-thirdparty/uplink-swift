import XCTest
@testable import libuplink
@testable import uplink_swift

//swiftlint:disable line_length
final class UplinkswiftTests: XCTestCase {
    var storjApiKey: String = ""
    // Storj V3 satellite address
    var storjSatellite: String = "us-central-1.tardigrade.io:7777"
    // Storj V3 encryption passphrase
    var storjEncryption: String = "test"
    // Storj bucket name
    var storjBucket: String = "demoswift"
    // Upload path within the bucket, where file will be uploaded.
    var storjUploadPath: String = "path/filename.txt"
    // Download path within the bucket, wherefrom the Storj object is to be downloaded.
    var storjDownloadPath: String = "path/filename.txt"
    //
    var downloadFileSizeOnStorj: Int64 = 0
    //
    var totalFileSizeInBytes: Int = 0
    //
    func createBucketTest(project: ProjectResultStr) {
        do {
            let createBucketInfo = try project.create_Bucket(bucket: self.storjBucket)
        //Checking for bucket created date is greater than 0
        XCTAssertGreaterThan(createBucketInfo.created, Int64(0))
        //Checking for bucket Name is equal to created bucket
            XCTAssertEqual(createBucketInfo.name, storjBucket)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    //
    //
    func statBucketTest(project: ProjectResultStr) {
        do {
            let statBucketInfo = try project.stat_Bucket(bucket: self.storjBucket)
        //Checking for bucket created date is greater than 0
        XCTAssertGreaterThan(statBucketInfo.created, Int64(0))
        //Checking for bucket Name is equal to created bucket
        XCTAssertEqual(statBucketInfo.name, storjBucket)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    //
    //
    func deleteBucketTest(project: ProjectResultStr) {
        do {
            let deleteBucket = try project.delete_Bucket(bucket: self.storjBucket)
        //Checking for bucket created date is greater than 0
        XCTAssertGreaterThan(deleteBucket.created, Int64(0))
        //Checking for bucket Name is equal to created bucket
        XCTAssertEqual(deleteBucket.name, storjBucket)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    //
    func listBucketTest(project: ProjectResultStr) {
        do {
            //
            var listBucketsOptions = ListBucketsOptions(cursor: "")
            //
            let bucketList = try project.list_Buckets(listBucketsOptions: &listBucketsOptions)
            //
            for bucket in bucketList {
                //Checking for bucket created date is greater than 0
                XCTAssertGreaterThan(bucket.created, Int64(0))
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    //
    func deleteObject(project: ProjectResultStr) {
        do {
            let deletedObjectInfo = try project.delete_Object(bucket: self.storjBucket, key: self.storjUploadPath)
            // Checking deleted object name is same as upload object name
            XCTAssertEqual(deletedObjectInfo.key, self.storjUploadPath)
            // Checking object creation time is more then 0
            XCTAssertGreaterThan(deletedObjectInfo.system.created, Int64(0))
            //
            XCTAssertGreaterThan(deletedObjectInfo.system.content_length, Int64(0))

        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func statObject(project: ProjectResultStr) {
        do {
            let objectInfo = try project.stat_Object(bucket: self.storjBucket, key: self.storjUploadPath)
            //
            XCTAssertEqual(objectInfo.key, self.storjUploadPath)
            //
            XCTAssertGreaterThan(objectInfo.system.created, Int64(0))
            //
            XCTAssertGreaterThan(objectInfo.system.content_length, Int64(0))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    //
    func testA() {
        do {
            let uplink = try Storj.uplink()
            let storjswiftPath = URL(fileURLWithPath: #file)
            var storjSwiftPathString = storjswiftPath.path
            XCTAssertNotNil(uplink, "Storj swift object is null")
            let fileManager = FileManager.default
            //
            //Checking if file exits or not
            if fileManager.fileExists(atPath: "secret.txt") {
                //
                let content = try String(contentsOfFile: "secret.txt")
                storjApiKey = content
                //
            } else if storjSwiftPathString.contains("uplink-swift/") {
                storjSwiftPathString = storjSwiftPathString.components(separatedBy: "Tests/uplink-swiftTests/")[0]
                storjSwiftPathString += "secret.txt"
                if fileManager.fileExists(atPath: storjSwiftPathString) {
                    do {
                        let content = try String(contentsOfFile: storjSwiftPathString)
                        storjApiKey = content

                    } catch {
                        XCTFail("Failed to read API Keys from file")
                        throw error
                    }
                }
                //
            } else {
                XCTFail("Failed to find secret.txt file")
                return
            }
            //
            // Getting access from storj V3 network
            let access = try uplink.request_Access_With_Passphrase(satellite: storjSatellite, apiKey: storjApiKey, encryption: storjEncryption)
            //
            // Opening project
            var project = try access.open_Project()
            defer {
                do {
                    // Closing project
                    try project.close()
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
            //
            // Testing create bucket function
            createBucketTest(project: project)
            //
            // Testing stat bucket function
            statBucketTest(project: project)
            //
            // Testing list bucket function
            listBucketTest(project: project)
            //
            // Testing upload object function
            uploadObject(project: &project)
            //
            // Testing stat object function
            statObject(project: project)
            //
            // Testing download object functions
            downloadObject(project: &project)
            //
            // Testing share access functions
            shareAccess(project: project, uplink: uplink, access: access)
            //
            // Testing delete object function
            deleteObject(project: project)
            //
            // Testing delete bucket function
            deleteBucketTest(project: project)
            //
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    static var allTests = [
        ("testA", testA)
    ]
}
