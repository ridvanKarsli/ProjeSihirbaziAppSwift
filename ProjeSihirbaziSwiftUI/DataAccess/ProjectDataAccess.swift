//
//  ProjectDataAccess.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class ProjectDataAccess: ProjectInterface{
    
    func getProject(tur: String, page: Int, sector: String, search: String, status: String, company: String, sortOrder: String, completion: @escaping ([Projects]?, Int?, String?) -> Void) {
            let urlString = APIEndpoints.getProjectURL(tur: tur, page: page, sector: sector, search: search, status: status, company: company, sortOrder: sortOrder)

            guard let url = URL(string: urlString) else {
                completion(nil, nil, "Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, nil, error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    completion(nil, nil, "No data received")
                    return
                }
                
                do {
                    // ResponseProject üzerinden yanıt çözümleme
                    let response = try JSONDecoder().decode(ResponseProject.self, from: data)
                    // Projeleri ve toplam sayfa sayısını döndürme
                    completion(response.items, response.totalPages, nil)
                } catch {
                    completion(nil, nil, "Error decoding data")
                }
            }
            
            task.resume()
    }
    
    
}

    // API'den dönen JSON yanıtındaki verileri modelleyen yapı
    struct ResponseProject: Codable {
        let currentPage: Int       // Şu anki sayfa numarası
        let pageSize: Int          // Sayfa başına öğe sayısı
        let totalItems: Int        // Toplam öğe sayısı
        let totalPages: Int        // Toplam sayfa sayısı
        let items: [Projects]      // Projelerin listesi
    }
