import Foundation

struct ProjeSihirbaziAI: Codable {
    var id: Int
    var userId: Int
    var chatHistoryJson: String
    var createdDateTime: String
    var lastDateTime: String
    var model: String
    
    init(id: Int, userId: Int, chatHistoryJson: String, createdDateTime: String, lastDateTime: String, model: String) {
        self.id = id
        self.userId = userId
        self.chatHistoryJson = chatHistoryJson
        self.createdDateTime = createdDateTime
        self.lastDateTime = lastDateTime
        self.model = model
    }
    
        func getId() -> Int {
           return self.id
       }

       func getUserId() -> Int {
           return self.userId
       }

       func getChatHistoryJson() -> String {
           return self.chatHistoryJson
       }

       func getCreatedDateTime() -> String {
           return self.createdDateTime
       }

       func getLastDateTime() -> String {
           return self.lastDateTime
       }

       func getModel() -> String {
           return self.model
       }

    
    func getOldChat(projectId: Int, token: String, completion: @escaping ([ProjeSihirbaziAI]?) -> Void) {
        // API URL'sini oluştur
        guard let url = URL(string: APIEndpoints.getOldChatURL(id: projectId)) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // URL isteği oluştur
        var request = URLRequest(url: url, timeoutInterval: 10.0) // Daha uygun bir timeout süresi
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // API isteği başlat
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Hata kontrolü
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // HTTP yanıt kontrolü
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }
            
            // Gelen veriyi kontrol et
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // JSON'u decode et
                let chats = try JSONDecoder().decode([ProjeSihirbaziAI].self, from: data)
                completion(chats)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    
    func createNewChat(projectId: Int, token: String, completion: @escaping (ProjeSihirbaziAI?) -> Void) {
        // URL'yi güvenli bir şekilde oluştur
        guard let url = URL(string: APIEndpoints.createNewChatURL(id: projectId)) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // URL isteği oluştur
        var request = URLRequest(url: url, timeoutInterval: 10.0) // Daha uygun bir timeout süresi
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        // API isteğini başlat
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Hata kontrolü
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // HTTP yanıt kontrolü
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("Server error: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }
            
            // Gelen veriyi kontrol et
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // Gelen veriyi logla (isteğe bağlı, sadece geliştirme sırasında kullanın)
                #if DEBUG
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Response JSON: \(json)")
                }
                #endif
                
                // JSON'u decode et
                let newChat = try JSONDecoder().decode(ProjeSihirbaziAI.self, from: data)
                print("Oluşturulan chat: \(newChat)")
                completion(newChat)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    
    func deleteChat(token: String, chatId: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: APIEndpoints.deleteChatURL(chatId: chatId)) else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let success = (200...299).contains(httpResponse.statusCode)
                completion(success)
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
    

    func getChatWithId(projectId: Int,chatId: Int, token: String, completion: @escaping ([ChatMessage]?) -> Void) {
        getOldChat(projectId: projectId, token: token) { chats in
            guard let chats = chats else {
                print("Failed to get chats")
                completion(nil)
                return
            }
            
            
            for chat in chats {
                print("Bütün chatte arananın id: \(chat.getId()), bizim aradığımız: \(chatId)")
                if chat.getId() == chatId {
                    do {
                        if let jsonData = chat.chatHistoryJson.data(using: .utf8) {
                            print("Dönüştürmeden hemen önce JSON: \(String(data: jsonData, encoding: .utf8) ?? "Geçersiz JSON")")
                            
                            let decoder = JSONDecoder()
                            let messages = try decoder.decode([ChatMessage].self, from: jsonData)
                            completion(messages)
                            return
                        } else {
                            print("JSON string could not be converted to Data.")
                        }
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key.stringValue)' not found:", context.debugDescription)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                    } catch {
                        print("JSON parsing error: \(error.localizedDescription)")
                    }
                }
            }
            
            print("Chat with id \(chatId) not found")
            completion(nil)
        }
    }
    
    func sendMessage(chatId: Int, message: String, token: String){
        guard let url = URL(string: APIEndpoints.sendMessageURL.url) else {
            print("Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let payload: [String: Any] = [
            "chatId": chatId,
            "message": message,
            "fileInfo": NSNull()
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("JSON verisi oluşturulamadı: \(error)")
            
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Hata: \(error)")
                
            } else if let data = data {
                // Data'yı String'e çevirip bir değişkene tutuyoruz
                if let responseString = String(data: data, encoding: .utf8) {
                    print("result: \(responseString)")

                } else {

                }
            } else {
 
            }
        }.resume()
    }
    

}

struct ChatMessage: Decodable, Equatable {
    var id : UUID = UUID()
    let sender: String
    let text: String
    let fileInfo: String?  // Null olabilir
    
    // JSON anahtarlarını struct içindeki değişkenlere eşleştiriyoruz
    private enum CodingKeys: String, CodingKey {
        case sender = "Sender"
        case text = "Text"
        case fileInfo = "FileInfo"
    }
}
