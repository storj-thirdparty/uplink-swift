import XCTest
@testable import libuplink
@testable import uplink_swift

//swiftlint:disable line_length
extension UplinkswiftTests {
    func downloadObject(project :inout ProjectResultStr) {
        do {
            var downloadFileSizeOnStorj: Int64 = 0
            let objectResultObjInfoObject = try project.stat_Object(bucket: self.storjBucket, key: storjDownloadPath)
            //
            XCTAssertEqual(objectResultObjInfoObject.key, self.storjUploadPath)
            //
            downloadFileSizeOnStorj = objectResultObjInfoObject.system.content_length
            //
            XCTAssertGreaterThan(objectResultObjInfoObject.system.content_length, 0)
            //
            XCTAssertGreaterThan(objectResultObjInfoObject.system.created, 0)

            downloadFile(project: &project, downloadFileSizeOnStorj: downloadFileSizeOnStorj)
        } catch {
            XCTFail("Error while downloading file")
        }
    }
    //
    func downloadFile(project:inout ProjectResultStr, downloadFileSizeOnStorj: Int64) {
        do {
            //Setting upload options
            var downloadOptions = DownloadOptions(offset: 0, length: -1)
            //
            let downloadResult = try  project.download_Object(bucket: self.storjBucket, key: self.storjDownloadPath, downloadOptions: &downloadOptions)
            //
            let bufferSize = 1000000
            let sizeToWrite = bufferSize
            //
            var receivedDataArray: [UInt8] = Array(repeating: 0, count: sizeToWrite)

            //
            let ptrtoreceivedData = receivedDataArray.withUnsafeMutableBufferPointer({pointerVal in return pointerVal.baseAddress!})
            //
            let bytesRead = try  downloadResult.read(data: ptrtoreceivedData, sizeToWrite: sizeToWrite)
            //
            let downloadedData = bytesRead
            if downloadedData < bufferSize {
                receivedDataArray.removeSubrange(downloadedData..<bufferSize)
            }
            //Fetching object info
            let downloadObjectInfo = try downloadResult.info()
            //
            XCTAssertGreaterThan(downloadObjectInfo.system.created, Int64(0), "Date of creation is incorrect")
            XCTAssertGreaterThan(downloadObjectInfo.system.content_length, Int64(0), "Size of file 0")
            //
            _ = try downloadResult.close()

        } catch {
            XCTFail("Failed to download file from storj V3 network")
        }
    }
}
