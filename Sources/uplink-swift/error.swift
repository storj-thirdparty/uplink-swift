import Foundation

var errorInternal = 0x02,
cancelledError = 0x03,
invalidHandleError = 0x04,
tooManyRequestsError = 0x05,
bandwidthLimitExceededError = 0x06,

bucketNameInvalidError = 0x10,
bucketAlreadyExistError = 0x11,
bucketNotEmptyError = 0x12,
bucketNotFoundError = 0x13,

objectKeyInvalidError = 0x20,
objectNotFoundError = 0x21,
uploadDoneError = 0x22,
libUplinkSoError = 0x9999
//
public class StorjException: Swift.Error {
    public let code: Int
    public let message: String
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}
//
public class InternalError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class LibUplinkSoError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class CancelledError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class InvalidHandleError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class TooManyRequestsError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class BandwidthLimitExceededError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class BucketNameInvalidError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class BucketAlreadyExistError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
public class BucketNotEmptyError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class BucketNotFoundError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class ObjectKeyInvalidError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class ObjectNotFoundError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//
public class UploadDoneError: StorjException {
    public override init(code: Int, message: String) {
        super.init(code: code, message: message)
    }
}
//swiftlint:disable cyclomatic_complexity
public func storjException(code: Int, message: String) -> Error {
    switch code {
    case errorInternal : return InternalError(code: code, message: message)
    case cancelledError : return CancelledError(code: code, message: message)
    case invalidHandleError : return InvalidHandleError(code: code, message: message)
    case tooManyRequestsError : return TooManyRequestsError(code: code, message: message)
    case bandwidthLimitExceededError : return BandwidthLimitExceededError(code: code, message: message)
    case bucketNameInvalidError : return BucketNameInvalidError(code: code, message: message)
    case bucketAlreadyExistError : return BucketAlreadyExistError(code: code, message: message)
    case bucketNotEmptyError : return BucketNotEmptyError(code: code, message: message)
    case bucketNotFoundError : return BucketNotFoundError(code: code, message: message)
    case objectKeyInvalidError : return ObjectKeyInvalidError(code: code, message: message)
    case objectNotFoundError : return ObjectNotFoundError(code: code, message: message)
    case uploadDoneError : return UploadDoneError(code: code, message: message)
    case libUplinkSoError : return LibUplinkSoError(code: code, message: message)
    default: return StorjException(code: code, message: message)
    }
}
