//
//  AcademicianInterface.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

protocol AcademicianInterface{
    func getAcademics(currentPage: Int, selectedName: String, selectedProvince: String, selectedUniversity: String, selectedKeywords: String, completion: @escaping ([Academician]?, String?, Int?) -> Void)
}
