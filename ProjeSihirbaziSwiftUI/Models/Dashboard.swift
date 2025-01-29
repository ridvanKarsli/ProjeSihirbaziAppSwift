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
