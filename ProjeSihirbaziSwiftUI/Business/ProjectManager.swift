//
//  ProjectManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class ProjectManager: ProjectInterface{
    
    private let projectDataAccess = ProjectDataAccess()
    
    func getProject(tur: String, page: Int, sector: String, search: String, status: String, company: String, sortOrder: String, completion: @escaping ([Projects]?, Int?, String?) -> Void) {
        projectDataAccess.getProject(tur: tur, page: page, sector: sector, search: search, status: status, company: company, sortOrder: sortOrder, completion: completion)
    }
    
    
}
