//
//  UserManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class UserManager: UserInterface{
    
    private let userInteface = UserDataAccess()
    
    func getUserData(token: String, completion: @escaping (User?) -> Void) {
        userInteface.getUserData(token: token, completion: completion);
    }
    
    func logIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        if (!email.isEmpty && !password.isEmpty){
            userInteface.logIn(email: email, password: password, completion: completion)
        }
    }
    
    func updateUserData(token: String, name: String, surname: String, imageFile: String, password: String, completion: @escaping (User?) -> Void) {
        userInteface.updateUserData(token: token, name: name, surname: surname, imageFile: imageFile, password: password, completion: completion)
    }
    
    func forgetPassword(email: String, completion: @escaping (String) -> Void) {
        userInteface.forgetPassword(email: email, completion: completion)
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        userInteface.refreshToken(completion: completion)
    }
    
    
}
