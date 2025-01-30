//
//  ProjeSihirbaziAIManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class ProjeSihirbaziAIManager: ProjeSihirbaziAIInterface{
    
    private let projeSihirbaziAIDataAccess = ProjeSihirbaziAIDataAccess()
    
    func getOldChat(projectId: Int, token: String, completion: @escaping ([ProjeSihirbaziAI]?) -> Void) {
        projeSihirbaziAIDataAccess.getOldChat(projectId: projectId, token: token, completion: completion)
    }
    
    func createNewChat(projectId: Int, token: String, completion: @escaping (ProjeSihirbaziAI?) -> Void) {
        projeSihirbaziAIDataAccess.createNewChat(projectId: projectId, token: token, completion: completion)
    }
    
    func deleteChat(token: String, chatId: Int, completion: @escaping (Bool) -> Void) {
        projeSihirbaziAIDataAccess.deleteChat(token: token, chatId: chatId, completion: completion)
    }
    
    func getChatWithId(projectId: Int, chatId: Int, token: String, completion: @escaping ([ChatMessage]?) -> Void) {
        projeSihirbaziAIDataAccess.getChatWithId(projectId: projectId, chatId: chatId, token: token, completion: completion)
    }
    
    func sendMessage(chatId: Int, message: String, token: String) {
        projeSihirbaziAIDataAccess.sendMessage(chatId: chatId, message: message, token: token)
    }
}
