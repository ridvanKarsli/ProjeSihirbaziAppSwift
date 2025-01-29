//
//  AcademicianRow.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 24.01.2025.
//

import SwiftUI

struct AcademicianRow: View {
    var academician: Academician
    
    var body: some View {
        HStack {
            if let imageUrl = URL(string: "https://projesihirbaziapi.enmdigital.com" + academician.getImageUrl()) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80) // Resim boyutunu büyüttük
                        .clipShape(Circle()) // Resmi yuvarlak hale getirdik
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1)) // Çerçeve ekledik
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80) // Resim boyutunu büyüttük
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            
            VStack(alignment: .leading) {
                Text(academician.getName())
                    .font(.headline)
                
                Text(academician.getUniversity())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(academician.getTitle())
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Text(academician.getSection())
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text(academician.getKeywords())
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.leading, 10) // Yazılar ile resim arasına boşluk ekledik
        }
        .padding(.vertical, 5) // Her satır arasında biraz boşluk
    }
}
