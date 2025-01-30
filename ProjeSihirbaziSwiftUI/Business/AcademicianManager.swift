//
//  AcademicianManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class AcademicianManager: AcademicianInterface{
    
    private let academicianDataAccess = AcademicianDataAccess()
    
    
    func getAcademics(currentPage: Int, selectedName: String, selectedProvince: String, selectedUniversity: String, selectedKeywords: String, completion: @escaping ([Academician]?, String?, Int?) -> Void) {
        
        academicianDataAccess.getAcademics(currentPage: currentPage, selectedName: selectedName, selectedProvince: selectedProvince, selectedUniversity: selectedUniversity, selectedKeywords: selectedKeywords, completion: completion)
    }
    
    
}
