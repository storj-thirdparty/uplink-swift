import Foundation
import libuplink
// swiftlint:disable line_length
extension Storj {
      //* function frees memory associated with the ProjectResult.
      //* pre-requisites: None
      //* inputs: ProjectResult
      //* output: None
       mutating public func free_Project_Result(projectResult:inout ProjectResult)throws {
           self.freeProjectResultFunc!(projectResult)
       }
    //
    //* function close the project.
    //* pre-requisites: open_Project function has been already called
    //* inputs: None
    //* output: UnsafeMutablePointer<Error>? or nil
     mutating public func close_Project(project:inout UnsafeMutablePointer<Project>)throws -> (UnsafeMutablePointer<Error>?) {
         let error = self.closeProjectFunc!(project)
         return error
     }
    //
    //* function to open project using access grant and config
    //* pre-requisites: request_Access_With_Passphrase or parse_Access function has been already called
    //* inputs: UnsafeMutablePointer<Access>
    //* output: ProjectResult
     mutating public func config_Open_Project(config: Config, access:inout UnsafeMutablePointer<Access>)throws -> (ProjectResult) {
         let projectResult = self.configOpenProjectFunc!(config, access)
         return projectResult
     }
    //* function to open project using access grant.
      //* pre-requisites:  request_Access_With_Passphrase or parse_Access function has been already called
      //* inputs: UnsafeMutablePointer<Access>
      //* output: ProjectResult
       mutating public func open_Project(access:inout UnsafeMutablePointer<Access>)throws -> (ProjectResult) {
        let projectResult = self.openProjectFunc!(access)
           return projectResult
       }
}
