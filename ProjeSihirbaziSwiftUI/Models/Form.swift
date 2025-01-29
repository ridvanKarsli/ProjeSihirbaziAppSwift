//
//  Form.swift
//  ProjeSihirbaziApp
//
//  Created by Rıdvan Karslı on 31.12.2024.
//

import Foundation

class Form{

    func postForm(email: String, message: String, name: String, company: String, phone: String) {
        guard let url = URL(string: APIEndpoints.postForm.url) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "message": message,
            "name": name,
            "company": company,
            "phone": phone
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error encoding parameters: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }
        }
        
        task.resume()
    }

    
}
