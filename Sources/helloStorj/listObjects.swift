import Foundation
import uplink_swift
import libuplink
//
// list objects will list all the object on storj V3 Network within desired storj bucket
// swiftlint:disable line_length
func listObjects(storjSwift:inout Storj, project:inout UnsafeMutablePointer<Project>, bucketName: NSString) {
    do {
        var listObjectsOptions = ListObjectsOptions()
        listObjectsOptions.recursive = true
        let prefix: NSString = "test/"
        let ptrPrefix = UnsafeMutablePointer<CChar>(mutating: prefix.utf8String)
        listObjectsOptions.prefix = ptrPrefix
        //
        var objectIterator = try  storjSwift.list_Objects(project: &project, storjBucketName: bucketName, listObjectsOptions: &listObjectsOptions)
        if objectIterator != nil {
            while try storjSwift.object_Iterator_Next(objectIterator: &(objectIterator)!) {
                var object = try storjSwift.object_Iterator_Item(objectIterator: &(objectIterator)!)
                if object != nil {
                    print("Object Info")
                    print("Object Name : ", String(validatingUTF8: (object?.pointee.key)!)!)
                    try storjSwift.free_Object(object: &(object)!)
                }
            }
            //
            var error = try  storjSwift.object_Iterator_Err(objectIterator: &(objectIterator)!)
            if error != nil {
                print("Error while listing object...")
                print("Error code : ", error?.pointee.code ?? 0, "\n Error message : ", String(validatingUTF8: (error?.pointee.message)!)!)
                try storjSwift.free_Error(error: &(error)!)
            } else {
                print("Object Listed Successfully !!")
            }
        }
        //free object ilterator
        try storjSwift.free_Object_Iterator(objectIterator: &(objectIterator)!)
    } catch {
        print(error)
    }
}
