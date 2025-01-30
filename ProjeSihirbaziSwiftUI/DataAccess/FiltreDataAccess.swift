//
//  FiltreDataAccess.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class FiltreDataAccess: FiltreInterface{
    
    func getKurumlar(tur: String, completion: @escaping ([String]) -> Void) {
        let urlString = APIEndpoints.getKurumURL(tur: tur)
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                completion([])
                return
            }

            do {
                let kurumlar = try JSONDecoder().decode([String].self, from: data)
                completion(kurumlar)
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    func getSektorler(completion: @escaping ([String]) -> Void) {
        let urlString = APIEndpoints.getSectors.url
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }

            do {
                let sectors = try JSONDecoder().decode([String].self, from: data)
                completion(sectors)
            } catch {
                print("JSON parsing error:ge \(error.localizedDescription)")
                completion([])
            }
        }

        task.resume()
    }
    
    func getIl(completion: @escaping ([String]) -> Void) {
           guard let url = URL(string: APIEndpoints.provinces.url) else {
               print("Invalid URL")
               completion([])
               return
           }
           
           var request = URLRequest(url: url, timeoutInterval: Double.infinity)
           request.httpMethod = "GET"

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   print("Error: \(String(describing: error))")
                   completion([])
                   return
               }

               do {
                   let provinces = try JSONDecoder().decode([String].self, from: data)
                   completion(provinces)
               } catch {
                   print("JSON parsing error: \(error.localizedDescription)")
                   completion([])
               }
           }

           task.resume()
       }
       
       func getUni(completion: @escaping ([String]) -> Void) {
           guard let url = URL(string: APIEndpoints.universities.url) else {
               print("Invalid URL")
               completion([])
               return
           }
           
           var request = URLRequest(url: url, timeoutInterval: Double.infinity)
           request.httpMethod = "GET"

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   print("Error: \(String(describing: error))")
                   completion([])
                   return
               }

               do {
                   let universities = try JSONDecoder().decode([String].self, from: data)
                   completion(universities)
               } catch {
                   print("JSON parsing error: \(error.localizedDescription)")
                   completion([])
               }
           }

           task.resume()
       }
       
       func getKeyword(completion: @escaping ([String]) -> Void) {
           guard let url = URL(string: APIEndpoints.keywordsurl.url) else {
               print("Invalid URL")
               completion([])
               return
           }
           
           var request = URLRequest(url: url, timeoutInterval: Double.infinity)
           request.httpMethod = "GET"

           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   print("Error: \(String(describing: error))")
                   completion([])
                   return
               }

               do {
                   let keywords = try JSONDecoder().decode([String].self, from: data)
                   completion(keywords)
               } catch {
                   print("JSON parsing error: \(error.localizedDescription)")
                   completion([])
               }
           }

           task.resume()
       }
   

}
