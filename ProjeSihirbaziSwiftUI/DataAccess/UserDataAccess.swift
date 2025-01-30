//
//  UserDataAccess.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class UserDataAccess: UserInterface{
    
    func getUserData(token: String, completion: @escaping (User?) -> Void) {
        guard let url = URL(string: APIEndpoints.updateAndData.url) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                // JSON verisini çözümleyip User nesnesi oluşturuyoruz
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let user = self.parseUser(from: jsonResponse)
                    completion(user)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(false)
            return
        }
        
        guard let url = URL(string: APIEndpoints.login.url) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("Sunucudan veri alınamadı.")
                    completion(false)
                    return
                }
                
                // JSON yanıtını parse et ve access token'ı al
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = jsonResponse["accessToken"] as? String,
                   let refreshToken = jsonResponse["refreshToken"] as? String {
                    // Token'ı UserDefaults'a kaydet
                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    func updateUserData(token: String, name: String, surname: String, imageFile: String, password: String, completion: @escaping (User?) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "surname": surname,
            "imageFile": imageFile,
            "password": password
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(nil)
            return
        }
        
        guard let url = URL(string: APIEndpoints.updateAndData.url) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let user = self.parseUser(from: jsonResponse)
                    completion(user)
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    func forgetPassword(email: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: APIEndpoints.forgetPassword.url) else {
            completion("Geçersiz URL")
            return
        }
        
        let requestBody: [String: String] = ["email": email]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            completion("JSON verisi oluşturulamadı")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion("Geçersiz yanıt formatı.")
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                    completion("Geçersiz yanıt (\(httpResponse.statusCode)): \(errorResponse)")
                } else {
                    completion("Geçersiz yanıt (\(httpResponse.statusCode)): Bilinmeyen hata.")
                }
                return
            }
            
            guard let data = data else {
                completion("Veri alınamadı.")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString) // Yanıt düz metin olarak işleniyor
            } else {
                completion("Veri okunamadı.")
            }
        }
        task.resume()
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("Refresh token bulunamadı")
            completion(false)
            return
        }
        
        // Refresh token endpoint URL
        let url = URL(string: APIEndpoints.refresToken.url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Gönderilecek JSON verisi
        let body: [String: Any] = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // API isteği
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(false)
                return
            }
            
            // Sunucudan gelen yanıtı işleme
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let newAccessToken = json["accessToken"] as? String,
                   let newRefreshToken = json["refreshToken"] as? String {
                    
                    // Yeni token'ları UserDefaults'a kaydet
                    UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                    UserDefaults.standard.set(newRefreshToken, forKey: "refreshToken")
                    
                    print("Token başarıyla yenilendi ve kaydedildi.")
                    completion(true)
                } else {
                    print("Yanıt işlenemedi veya eksik veri.")
                    completion(false)
                }
            } catch {
                print("JSON çözümleme hatası: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private func parseUser(from jsonResponse: [String: Any]) -> User {
        let id = jsonResponse["id"] as? Int ?? 0
        let name = jsonResponse["name"] as? String ?? ""
        let surname = jsonResponse["surname"] as? String ?? ""
        let email = jsonResponse["email"] as? String ?? ""
        let phone = jsonResponse["phone"] as? String ?? ""
        let imageFile = jsonResponse["imageFile"] as? String ?? ""
        let role = jsonResponse["role"] as? String ?? ""
        return User(id: id, name: name, surname: surname, email: email, phone: phone, imageFile: imageFile, role: role)
    }
    
}
