import Foundation
import libuplink

extension Storj {
    //
      //* function frees memory associated with the Error.
      //* pre-requisites: None
      //* inputs: inout UnsafeMutablePointer<Error>
      //* output: None
       mutating public func free_Error(error:inout UnsafeMutablePointer<Error>)throws {
        self.freeErrorFunc!(error)
       }
}
