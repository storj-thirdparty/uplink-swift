import libuplink
import Foundation

//swiftlint:disable identifier_name
public class UplinkBucket {
    public var name: String
    public var created: Int64
    public init(name: String = "", created: Int64 = 0) {
        self.name = name
        self.created = created
    }
}

//
public class UplinkSystemMetadata {
    public var created: Int64
    public var expires: Int64
    public var content_length: Int64
    public init(created: Int64 = 0, expires: Int64 = 0, content_length: Int64 = 0) {
        self.created = created
        self.expires = expires
        self.content_length = content_length
    }
}
//
public class UplinkCustomMetadata {
    public var entries: [UplinkCustomMetadataEntry]
    public var count: Int
    public init(entries: [UplinkCustomMetadataEntry] = [], count: Int = 0) {
        self.entries = entries
        self.count = count
    }
}
//
public class UplinkCustomMetadataEntry {
    public var key: String
    public var key_length: Int
    public var value: String
    public var value_length: Int
    public init(key: String = "", key_length: Int = 0, value: String = "", value_length: Int = 0) {
        self.key = key
        self.key_length = key_length
        self.value = value
        self.value_length = value_length

    }
}
//
//
public class UplinkObject {
    //
    public var key: String
    public var is_prefix: Bool
    public var system: UplinkSystemMetadata
    public var custom: UplinkCustomMetadata
    public init(key: String, is_prefix: Bool, system: UplinkSystemMetadata, custom: UplinkCustomMetadata) {
        self.key = key
        self.is_prefix = is_prefix
        self.system = system
        self.custom = custom
    }
}
//
//
public class UplinkSharePrefix {
    public var bucket: String
    public var prefix: String
    public init(bucket: String = "", prefix: String = "") {
        self.bucket = bucket
        self.prefix = prefix
    }
}
//
public class UplinkListBucketsOptions {
    public var cursor: String
    public init(cursor: String = "") {
        self.cursor = cursor
    }
}
//
//swiftlint:disable line_length
public class UplinkListObjectsOptions {
    public var prefix: String
    public var cursor: String
    public var recursive: Bool
    public var system: Bool
    public var custom: Bool
    public init(prefix: String = "", cursor: String = "", recursive: Bool = false, system: Bool = false, custom: Bool = false) {
        self.prefix = prefix
        self.cursor = cursor
        self.recursive = recursive
        self.system = system
        self.custom = custom
    }
}

public class UplinkConfig {
    public var user_agent: String
    public var dial_timeout_milliseconds: Int32
    public var temp_directory: String
    public init(user_agent: String = "", dial_timeout_milliseconds: Int32 = 0, temp_directory: String = "") {
        self.user_agent = user_agent
        self.dial_timeout_milliseconds = dial_timeout_milliseconds
        self.temp_directory = temp_directory
    }
}

public class UplinkPermission {
    public var allow_download: Bool
    public var allow_upload: Bool
    public var allow_list: Bool
    public var allow_delete: Bool
    public var not_before: Int64
    public var not_after: Int64
    public init(allow_download: Bool  = false, allow_upload: Bool = false, allow_list: Bool = false, allow_delete: Bool = false, not_before: Int64 = 0, not_after: Int64 = 0) {
        self.allow_download = allow_download
        self.allow_upload = allow_upload
        self.allow_list = allow_list
        self.allow_delete = allow_delete
        self.not_before = not_before
        self.not_after = not_after
    }
}
//
public class UplinkUploadOptions {
    public var expires: Int64
    public init(expires: Int64 = 0) {
        self.expires = expires
    }
}
//
public class UplinkDownloadOptions {
    public var offset: Int64
    public var length: Int64
    public init(offset: Int64 = 0, length: Int64 = 0) {
        self.offset = offset
        self.length = length
    }
}
