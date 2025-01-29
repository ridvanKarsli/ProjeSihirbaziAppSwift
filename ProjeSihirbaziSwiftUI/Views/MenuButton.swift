//
//  MenuButton.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 24.01.2025.
//

import SwiftUI

struct MenuButton: View {
    var title: String
    var iconName: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 5)
        .frame(height: 120) // Butonları daha büyük yapmak için yükseklik ayarı
    }
}
