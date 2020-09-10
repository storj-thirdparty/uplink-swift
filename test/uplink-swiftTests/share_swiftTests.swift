import XCTest
@testable import libuplink
@testable import uplink_swift

extension UplinkswiftTests {
    func shareAccess(project: ProjectResultStr, uplink: Storj, access: AccessResultStr) {
        do {
            var permission = Permission(allow_download: true, allow_upload: true, allow_list: true, allow_delete: true, not_before: 0, not_after: 0)
            //
            let sharePrefix = SharePrefix(bucket: storjBucket, prefix: "path/")
            //
            var sharePrefixArray: [SharePrefix] = []
            sharePrefixArray.append(sharePrefix)
            //
            let accessShareResult = try access.share(permission: &permission, prefix: &sharePrefixArray)
            //
            let accessString = try accessShareResult.serialize()
            //AccessString
            //
            _ = try uplink.parse_Access(stringKey: accessString)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
