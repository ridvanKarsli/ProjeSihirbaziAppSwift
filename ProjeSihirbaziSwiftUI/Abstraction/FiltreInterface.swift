//
//  FiltreInterface.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 30.01.2025.
//

import Foundation

protocol FiltreInterface{
    
    func getKurumlar(tur: String, completion: @escaping ([String]) -> Void)
    func getSektorler(completion: @escaping ([String]) -> Void)
    func getIl(completion: @escaping ([String]) -> Void)
    func getUni(completion: @escaping ([String]) -> Void)
    func getKeyword(completion: @escaping ([String]) -> Void)
}
