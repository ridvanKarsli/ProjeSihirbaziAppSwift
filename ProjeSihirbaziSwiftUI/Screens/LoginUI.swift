import SwiftUI

struct LoginUI: View {
    //variables
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var navigateToHome: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var showForgotPassword: Bool = false
    @State private var forgotPasswordEmail: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 50)

            // E-Mail
            TextField("E-posta", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .padding(.top, 20)

            // password
            HStack {
                if isPasswordVisible {
                    TextField("Şifre", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                } else {
                    SecureField("Şifre", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 20)

            // Login button
            Button(action: {
                login()
            }) {
                Text("Giriş Yap")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .font(.headline)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                MainMenuUI() //to login view
            }
            .padding(.top, 30)

            // Forget password
            Button(action: {
                showForgotPasswordAlert()
            }) {
                Text("Şifremi Unuttum?")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Giriş Yap")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Uyarı"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
        .overlay(
            // Yükleniyor göstergesi
            Group {
                if isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        .padding(50)
                }
            }
        )
        .onAppear {
            
            if isLoggedIn {
                navigateToHome = true
            }
        }
    }

    func showForgotPasswordAlert() {
        let alertController = UIAlertController(title: "Şifremi Unuttum", message: "E-posta adresinizi girin", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "E-posta adresinizi girin"
            textField.keyboardType = .emailAddress
        }

        alertController.addAction(UIAlertAction(title: "Gönder", style: .default, handler: { _ in
            if let email = alertController.textFields?.first?.text, !email.isEmpty {
                self.forgotPasswordEmail = email
                
                
                forgetPassword { message in
                    print("alert çalıştı")
                    print(message)
                    showAlert(message: message)
                }
            } else {
                showAlert(message: "Lütfen geçerli bir e-posta girin.")
            }
        }))

        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let topController = keyWindow.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }

    }

    func forgetPassword(completion: @escaping (String) -> Void) {
        let userDataAccess = UserManager()
        userDataAccess.forgetPassword(email: forgotPasswordEmail) { message in
            // İşlem sonucunu completion handler üzerinden döndür
            completion(message)
        }
    }
   

    func login() {
        let userDataAccess = UserManager();

        isLoading = true
        userDataAccess.logIn(email: email, password: password) { success in
            DispatchQueue.main.async {
                isLoading = false // Yükleniyor bittiğinde false yapıyoruz
                if success {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.navigateToHome = true
                } else {
                    self.showAlert(message: "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginUI()
    }
}

#Preview {
    LoginUI()
}
