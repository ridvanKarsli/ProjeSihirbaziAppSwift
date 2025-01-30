import Foundation
class Dashboard {
    
    private var grantCount: Int
    private var academicianCount: Int
    private var tenderCount: Int
    
    init(grantCount: Int = 0, academicianCount: Int = 0, tenderCount: Int = 0) {
        self.grantCount = grantCount
        self.academicianCount = academicianCount
        self.tenderCount = tenderCount
    }
    
    func getGrantCount() -> Int {
        return self.grantCount
    }

    func getAcademicianCount() -> Int {
        return self.academicianCount
    }

    func getTenderCount() -> Int {
        return self.tenderCount
    }

}
