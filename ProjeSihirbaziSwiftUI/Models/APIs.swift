//
//  APIs.swift
//  ProjeSihirbaziApp
//
//  Created by Rıdvan Karslı on 1.01.2025.
//

import Foundation

enum APIEndpoints: String {
    
    private static let baseUrl = "https://projesihirbaziapi.enmdigital.com"
    
    case login = "/Auth/login"
    case updateAndData = "/Auth/me"
    case postForm = "/ContactForm/antremakine-send-message"
    case getSectors = "/ScrapedProject/sectors"
    case dashboard = "/App/dashboard"
    case provinces = "/Academician/provinces"
    case universities = "/Academician/universities"
    case keywordsurl = "/Academician/keywords"
    case getModelsURL = "/ProjeSihirbaziAI/models"
    case sendMessageURL = "/ProjeSihirbaziAI/ask"
    case forgetPassword = "/Auth/forgot-password"
    case refresToken = "/Auth/refresh-token"

    var url: String {
        return APIEndpoints.baseUrl + self.rawValue
    }
    
    static func getProjectURL(tur: String, page: Int, sector: String, search: String, status: String, company: String, sortOrder: String) -> String {
        return "https://projesihirbaziapi.enmdigital.com/ScrapedProject/projects?tur=\(tur)&page=\(page)&sector=\(sector)&search=\(search)&submissionStatus=\(status)&company=\(company)&sortOrder=\(sortOrder)"
    }
    
    static func getKurumURL(tur: String) ->String{
        return "https://projesihirbaziapi.enmdigital.com/ScrapedProject/companies?tur=\(tur)"
    }
    
    static func deleteChatURL(chatId: Int) -> String{
        return "https://projesihirbaziapi.enmdigital.com/ProjeSihirbaziAI/delete-chat/\(chatId)"
    }
    
    static func getOldChatURL(id : Int) -> String{
        return "https://projesihirbaziapi.enmdigital.com/ProjeSihirbaziAI/chats/ProjeSihirbazı-\(id)"
    }
    
    static func createNewChatURL(id: Int) -> String{
        return "https://projesihirbaziapi.enmdigital.com/ProjeSihirbaziAI/new-chat/ProjeSihirbazı-\(id)"
    }
    
    static func getAcademicsURL(currentPage: Int, selectedName: String, selectedProvince: String, selectedUniversity: String, selectedKeywords: String) -> String{
        return "https://projesihirbaziapi.enmdigital.com/Academician/academicians?page=\(currentPage)&search=\(selectedName)&province=\(selectedProvince)&university=\(selectedUniversity)&keyword=\(selectedKeywords)"
    }
}
  
