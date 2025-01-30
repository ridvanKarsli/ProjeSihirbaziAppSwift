//
//  ProjeSihirbaziAIInterface.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

protocol ProjeSihirbaziAIInterface{
    func getOldChat(projectId: Int, token: String, completion: @escaping ([ProjeSihirbaziAI]?) -> Void)
    func createNewChat(projectId: Int, token: String, completion: @escaping (ProjeSihirbaziAI?) -> Void)
    func deleteChat(token: String, chatId: Int, completion: @escaping (Bool) -> Void)
    func getChatWithId(projectId: Int,chatId: Int, token: String, completion: @escaping ([ChatMessage]?) -> Void)
    func sendMessage(chatId: Int, message: String, token: String)
}
