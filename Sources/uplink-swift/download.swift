import Foundation
import libuplink

//
//swiftlint:disable line_length
public class DownloadResultStr {
    var download: UplinkDownload
    var uplink: Storj
    var downloadResult: UplinkDownloadResult?

    public init(uplink: Storj, download: UplinkDownload, downloadResult: UplinkDownloadResult? = nil) {
        self.download = download
        self.uplink = uplink
        if downloadResult != nil {
            self.downloadResult = downloadResult
        }
    }
    //
    // function returns information about the downloaded object.
    // Input : None
    // Output : ObjectInfo (UplinkObject)
    public func info() throws ->(Object) {
        do {
            let objectResult = self.uplink.downloadInfoFunc!(&self.download)
            //
            if objectResult.object != nil {
                return uplinkObjectToSwift(uplinkObject: objectResult.object.pointee)
            }
            //
            if objectResult.error != nil {
                throw storjException(code: Int(objectResult.error.pointee.code), message: String(validatingUTF8: (objectResult.error.pointee.message!))!)
            }
            //
            return Object(key: "", is_prefix: false, system: SystemMetadata(), custom: CustomMetadata(entries: [], count: 0))
        } catch {
            throw error
        }
    }
    //
    // function closes the download.
    // Input : None
    // Output : None
    public func close() throws {
        do {
            let error = self.uplink.closeDownloadFunc!(&self.download)
            //
            defer {
                if error != nil {
                    self.uplink.freeErrorFunc!(error!)

                }
            }
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
        } catch {
            throw error
        }
    }
    // function downloads up to len size_to_read bytes from the object's data stream.
    // It returns the data_read in bytes and number of bytes read
    // Input : Buffer (UnsafeMutablePointer<UInt8>), Buffer length (Int)
    // Output : ReadResult (Int)
    public func read(data: UnsafeMutablePointer<UInt8>, sizeToWrite: Int) throws ->(Int) {
        do {
            let readResult = self.uplink.downloadReadFunc!(&self.download, data, sizeToWrite)
            //
            if readResult.error == nil {
                return readResult.bytes_read
            } else {
                if readResult.error != nil {
                throw storjException(code: Int(readResult.error.pointee.code), message: String(validatingUTF8: (readResult.error.pointee.message!))!)
                } else {
                    throw storjException(code: 9999, message: "Read result and error is nil")
                }
            }
        } catch {
            throw error
        }
    }

}
