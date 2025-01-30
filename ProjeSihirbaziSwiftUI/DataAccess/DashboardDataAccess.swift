//
//  DashboardDataAccess.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class DashboardDataAccess: DashboardInterface{
    
    func getDashboardData(completion: @escaping (Dashboard?) -> Void) {
        var request = URLRequest(url: URL(string: APIEndpoints.dashboard.url)!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    print("Veri alınamadı.")
                    completion(nil)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let grantCount = json["grantCount"] as? Int ?? 0
                        let academicianCount = json["academicianCount"] as? Int ?? 0
                        let tenderCount = json["tenderCount"] as? Int ?? 0
                        
                        let dashboard = Dashboard(grantCount: grantCount, academicianCount: academicianCount, tenderCount: tenderCount)
                        completion(dashboard)  // Dashboard nesnesini döndür
                    }
                } catch {
                    print("JSON ayrıştırma hatası: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
}
