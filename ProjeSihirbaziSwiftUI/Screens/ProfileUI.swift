//
//  ProfileUI.swift
//  ProjeSihirbaziSwiftUI
//
//  Created by Rıdvan Karslı on 4.01.2025.
//

import SwiftUI
import UIKit

struct ProfileUI: View {
    @State private var profileImage: UIImage? = nil
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var newPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var imagePickerPresented: Bool = false
    @State private var isLogOut: Bool = false
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profil Resmi
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 110, height: 150)

                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                        }
                    }
                    .onTapGesture {
                        imagePickerPresented = true
                    }

                    // TextField'lar
                    TextField("Ad", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Soyad", text: $surname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("E-posta", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .disabled(true)
                    
                    TextField("Telefon", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Güncelle Butonu
                    Button("Güncelle") {
                        updateUserData()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Çıkış Yap Butonu
                    Button("Çıkış Yap") {
                        logOut()
                        isLogOut = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                }
                .padding(.vertical)
            }
            .navigationTitle("Profil")
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Uyarı"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
            .sheet(isPresented: $imagePickerPresented) {
                ImagePicker(selectedImage: $profileImage)
            }
            .fullScreenCover(isPresented: $isLogOut) {
                BeforeLoginUI()
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear(){
                isLoading = true
                performTokenRefresh()
                if let token = UserDefaults.standard.string(forKey: "accessToken") {
                    getUserData(token: token)
                }
            }
        }
    }

    // Kullanıcı verilerini çekme
    func getUserData(token: String) {
        let userDataAccess = UserManager()
        
        userDataAccess.getUserData(token: token) { fetchedUser in
            DispatchQueue.main.async {
                if let fetchedUser = fetchedUser {
                    self.name = fetchedUser.getName()
                    self.surname = fetchedUser.getSurname()
                    self.email = fetchedUser.getEmail()
                    self.phone = fetchedUser.getPhone()
                    
                    if let url = URL(string: fetchedUser.getImageFile() ?? "") {
                        loadImage(from: url)
                    }
                } else {
                    alertMessage = "Kullanıcı verileri alınamadı."
                    showAlert = true
                }
            }
        }
    }
    
    // Kullanıcı verilerini güncelleme
    func updateUserData() {
        let userDataAccess = UserManager()
        
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            
            
            userDataAccess.updateUserData(token: token, name: name, surname: surname, imageFile: "", password: newPassword) { updatedUser in
                DispatchQueue.main.async {
                    if let updatedUser = updatedUser {
                        self.name = updatedUser.getName()
                        self.surname = updatedUser.getSurname()
                        self.email = updatedUser.getEmail()
                        self.phone = updatedUser.getPhone()
                        
                        alertMessage = "Kullanıcı bilgileri başarıyla güncellendi."
                        showAlert = true
                    } else {
                        alertMessage = "Güncelleme başarısız."
                        showAlert = true
                    }
                }
            }
        }
    }
    
    // Çıkış yapma
    func logOut() {
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    // Resim yükleme
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }.resume()
    }
    
    func performTokenRefresh() {
        let userDataAccess = UserManager()
        
            userDataAccess.refreshToken { success in
            if success {
                print("Token başarıyla yenilendi.")
            } else {
                print("Token yenileme başarısız.")
            }
        }
    }
}

#Preview {
    ProfileUI()
}
