import Foundation
import UIKit

// Akademisyen modelini tanımlıyoruz.
class Academician: Codable, Identifiable  {
    var title: String
    var name: String
    var section: String
    var keywords: String
    var imageUrl: String
    var university: String
    var province: String
    
    // Constructor (initializer)
    init(title: String, name: String, section: String, keywords: String, imageUrl: String, university: String, province: String) {
        self.title = title
        self.name = name
        self.section = section
        self.keywords = keywords
        self.imageUrl = imageUrl
        self.university = university
        self.province = province
    }
    
    // Getter metodları
    func getTitle() -> String {
        return self.title
    }

    func getName() -> String {
        return self.name
    }

    func getSection() -> String {
        return self.section
    }

    func getKeywords() -> String {
        return self.keywords
    }

    func getImageUrl() -> String {
        return self.imageUrl
    }

    func getUniversity() -> String {
        return self.university
    }

    func getProvince() -> String {
        return self.province
    }

    func getAcademics(currentPage: Int,
                      selectedName: String,
                      selectedProvince: String,
                      selectedUniversity: String,
                      selectedKeywords: String,
                      completion: @escaping ([Academician]?, String?, Int?) -> Void) {
        guard let url = URL(string: APIEndpoints.getAcademicsURL(currentPage: currentPage, selectedName: selectedName, selectedProvince: selectedProvince, selectedUniversity: selectedUniversity, selectedKeywords: selectedKeywords)) else {
            completion(nil, "Geçersiz URL", nil)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error.localizedDescription, nil)
                    return
                }
                guard let data = data else {
                    completion(nil, "Veri alınamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")", nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ResponseAcademican.self, from: data)
                    
                    // Başarıyla veriyi aldık, sonucu callback fonksiyonuna gönderiyoruz
                    completion(response.items, nil, response.totalPages)
                } catch {
                    completion(nil, "JSON ayrıştırma hatası: \(error.localizedDescription)", nil)
                }
            }
        }
        
        task.resume()
    }

}

// API'den gelen yanıtın modeli
struct ResponseAcademican: Codable {
    let currentPage: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    let items: [Academician]
}

