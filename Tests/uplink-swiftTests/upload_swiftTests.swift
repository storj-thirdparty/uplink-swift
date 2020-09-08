import XCTest
@testable import libuplink
@testable import uplink_swift

//swiftlint:disable line_length
extension UplinkswiftTests {
    func uploadObject(project :inout ProjectResultStr) {
        do {
            //
            var uploadOptions = UploadOptions()
            //
            let upload = try project.upload_Object(bucket: self.storjBucket, key: self.storjUploadPath, uploadOptions: &uploadOptions)
            // Reading data from the file for uploading on storj V3
            //
            let dataToUpload = "Hello Storj"
            //
            var dataInUint = [UInt8](dataToUpload.utf8)
            //
            let dataWritten = try  upload.write(data: &dataInUint, sizeToWrite: dataInUint.count)
            //
            XCTAssertGreaterThan(dataWritten, 0, "Data Written on storj")
            //
            dataInUint.removeAll(keepingCapacity: false)
            setCustomMetaData(project: project, upload: upload)
                //
            let uploadObjectInfo = try upload.info()
            //
            XCTAssertEqual(uploadObjectInfo.key, storjUploadPath)
            //
            XCTAssertGreaterThan(uploadObjectInfo.system.content_length, Int64(0), "File Size is 0")
            XCTAssertGreaterThan(uploadObjectInfo.system.created, Int64(0), "Date of creation is incorrect")
            //
        } catch {
            XCTFail("Failed to upload file on storj V3 network")
        }
    }

    func setCustomMetaData(project: ProjectResultStr, upload: UploadResultStr) {
        do {
            //
            let keyString: String = "change-me-to-desired-key"
            //
            let entries = CustomMetadataEntry(key: keyString, key_length: keyString.count, value: keyString, value_length: keyString.count)
            //
            let entriesArray = [entries]
            var customMetaDataObj = CustomMetadata(entries: entriesArray, count: entriesArray.count)
            //
            try upload.set_Custom_Metadata(customMetadata: &customMetaDataObj)
            //
            try  upload.commit()

        } catch {
            XCTFail("Failed to upload file on storj V3 network")
        }
    }
}
