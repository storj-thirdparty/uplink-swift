import libuplink

//swiftlint:disable line_length
public class ProjectResultStr {
    //
    var project: UplinkProject
    var uplink: Storj
    var projectResult: UplinkProjectResult?
    //
    public init(uplink: Storj, project: UplinkProject, projectResult: UplinkProjectResult? = nil) {
        self.project = project
        self.uplink = uplink
        if projectResult != nil {
            self.projectResult = projectResult
        }
    }
    //
    // function closes the project and all associated resources.
    // Input : None
    // Output : None
    public func close()throws {
        do {
            //
            let error = self.uplink.closeProjectFunc!(&self.project)
            defer {
                self.uplink.freeProjectResultFunc!(self.projectResult!)
                if error != nil {
                    self.uplink.freeErrorFunc!(error!)

                }
            }
            //
            if error != nil {
                throw storjException(code: Int(error!.pointee.code), message: String(validatingUTF8: (error!.pointee.message!))!)
            }
        } catch {
            throw error
        }
    }
}
