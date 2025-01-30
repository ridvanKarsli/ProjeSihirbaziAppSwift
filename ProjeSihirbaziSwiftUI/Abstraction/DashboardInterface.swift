//
//  DashboardInterface.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

protocol DashboardInterface{
    func getDashboardData(completion: @escaping (Dashboard?) -> Void) 
}
