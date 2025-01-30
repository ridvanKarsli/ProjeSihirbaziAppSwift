//
//  DashboardManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class DashboardManager: DashboardInterface{
    
    private let dashboardDataAccess = DashboardDataAccess()
    
    func getDashboardData(completion: @escaping (Dashboard?) -> Void) {
        dashboardDataAccess.getDashboardData(completion: completion)
    }
    
    
}
