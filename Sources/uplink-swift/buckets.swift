import libuplink
import Foundation
//
//swiftlint:disable line_length
extension ProjectResultStr {
    //
    // function creates a new bucket.
    // Input : BucketName (String)
    // Output : UplinkBucket (Object)
    public func create_Bucket(bucket: String) throws ->(Bucket) {
        do {
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            var bucketResult = self.uplink.createBucketFunc!(&self.project, ptrBucketName)
            //
            defer {
                self.uplink.freeBucketResultFunc!(bucketResult)
            }
            //
            if bucketResult.bucket != nil {
                return Bucket(name: String(validatingUTF8: (bucketResult.bucket.pointee.name )!)!, created: bucketResult.bucket.pointee.created)
            }
            // Checking if error returned
            if bucketResult.error != nil {
                throw storjException(code: Int(bucketResult.error.pointee.code), message: String(validatingUTF8: (bucketResult.error.pointee.message!))!)
            }
            //
            return Bucket()
        } catch {
            throw error
        }
    }
    //
    // function ensures that a bucket exists or creates a new one.
    // When bucket already exists it returns a valid Bucket and no error
    // Input : BucketName (String)
    // Output : UplinkBucket (Object)
    public func ensure_Bucket(bucket: String) throws ->(Bucket) {
        do {
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            //
            var bucketResult = self.uplink.ensureBucketFunc!(&self.project, ptrBucketName)
            //
            defer {
                self.uplink.freeBucketResultFunc!(bucketResult)
            }
            //
            if bucketResult.bucket != nil {
                return Bucket(name: String(validatingUTF8: (bucketResult.bucket.pointee.name )!)!, created: bucketResult.bucket.pointee.created)
            }
            // Checking if error returned
            if bucketResult.error != nil {
                throw storjException(code: Int(bucketResult.error.pointee.code), message: String(validatingUTF8: (bucketResult.error.pointee.message!))!)
            }
            //
            return Bucket()
        } catch {
            throw error
        }
    }
    //
    // function returns information about a bucket.
    // Input : BucketName (String)
    // Output : UplinkBucket (Object)
    public func stat_Bucket(bucket: String) throws ->(Bucket) {
        do {
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            //
            var bucketResult = self.uplink.statBucketFunc!(&self.project, ptrBucketName)
            //
            defer {
                self.uplink.freeBucketResultFunc!(bucketResult)
            }
            //
            if bucketResult.bucket != nil {
                return Bucket(name: String(validatingUTF8: (bucketResult.bucket.pointee.name )!)!, created: bucketResult.bucket.pointee.created)
            }
            // Checking if error returned
            if bucketResult.error != nil {
                throw storjException(code: Int(bucketResult.error.pointee.code), message: String(validatingUTF8: (bucketResult.error.pointee.message!))!)
            }
            //
            return Bucket()
        } catch {
            throw error
        }
    }
    //
    // function deletes a bucket.
    // When bucket is not empty it throws BucketNotEmptyError exception.
    // Input : BucketName (String)
    // Output : UplinkBucket (Object)
    public func delete_Bucket(bucket: String) throws ->(Bucket) {
        do {
            //
            let ptrBucketName = UnsafeMutablePointer<CChar>(mutating: (bucket as NSString).utf8String)
            //
            var bucketResult = self.uplink.deleteBucketFunc!(&self.project, ptrBucketName)
            //
            defer {
                self.uplink.freeBucketResultFunc!(bucketResult)
            }
            //
            if bucketResult.bucket != nil {
                //
                return Bucket(name: String(validatingUTF8: (bucketResult.bucket.pointee.name )!)!, created: bucketResult.bucket.pointee.created)
            }
            // Checking if error returned
            if bucketResult.error != nil {
                throw storjException(code: Int(bucketResult.error.pointee.code), message: String(validatingUTF8: (bucketResult.error.pointee.message!))!)
            }
            //
            return Bucket()
        } catch {
            throw error
        }
    }
    //
    // function returns a list of buckets with all its information.
    // Input : ListBucketOptions (Object)
    // Output : List of UplinkBucket (Object)
    public func list_Buckets(listBucketsOptions:inout ListBucketsOptions) throws->([Bucket]) {
        do {
            //
            var bucketList: [Bucket] = []
            //
            var listBucketsOptionsUplink = UplinkListBucketsOptions()
            let ptrCursor = UnsafePointer<CChar>((listBucketsOptions.cursor as NSString).utf8String)
            listBucketsOptionsUplink.cursor = ptrCursor
            var bucketIterator = self.uplink.listBucketsFunc!(&self.project, &listBucketsOptionsUplink)
            //
            defer {
                if bucketIterator != nil {
                    self.uplink.freeBucketIteratorFunc!(bucketIterator!)
                }

            }
            //
            if bucketIterator != nil {
                while self.uplink.bucketIteratorNextFunc!(bucketIterator!) {
                    let bucket = self.uplink.bucketIteratorItemFunc!(bucketIterator!)
                    if bucket != nil {
                        bucketList.append(Bucket(name: String(validatingUTF8: (bucket!.pointee.name )!)!, created: bucket!.pointee.created))
                        self.uplink.freeBucketFunc!(bucket!)
                    }
                }
                //
                let error = self.uplink.bucketIteratorErrorFunc!(bucketIterator!)
                defer {
                    if error != nil {
                        self.uplink.freeErrorFunc!(error!)

                    }
                }
                if error != nil {
                    throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
                }

            }
            //
            return bucketList
        } catch {
            throw error
        }
    }
}
