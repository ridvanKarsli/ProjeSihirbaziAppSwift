//
//  FiltreManager.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

class FiltreManager: FiltreInterface{
    
    private let filtreDataAccess = FiltreDataAccess()
    
    func getKurumlar(tur: String, completion: @escaping ([String]) -> Void) {
        filtreDataAccess.getKurumlar(tur: tur, completion: completion)
    }
    
    func getSektorler(completion: @escaping ([String]) -> Void) {
        filtreDataAccess.getSektorler(completion: completion)
    }
    
    func getIl(completion: @escaping ([String]) -> Void) {
        filtreDataAccess.getIl(completion: completion)
    }
    
    func getUni(completion: @escaping ([String]) -> Void) {
        filtreDataAccess.getUni(completion: completion)
    }
    
    func getKeyword(completion: @escaping ([String]) -> Void) {
        filtreDataAccess.getKeyword(completion: completion)
    }
    
    
}
