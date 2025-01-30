//
//  ProjectInterface.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

protocol ProjectInterface{
    
    func getProject(tur: String, page: Int, sector: String, search: String, status: String, company: String, sortOrder: String, completion: @escaping ([Projects]?, Int?, String?) -> Void)
}
