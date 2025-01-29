import SwiftUI

struct BeforeLoginUI: View {
    //variables
    @State private var isLoginActive = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                
            
                VStack(spacing: 20) {
                    // Login button
                    Button(action: {
                        isLoginActive = true
                    }) {
                        Text("Giriş Yap")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.headline)
                            .shadow(radius: 5)
                    }
                    .navigationDestination(isPresented: $isLoginActive) {
                        LoginUI() //to login view
                    }
                }
                .padding(.horizontal, 40)
                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    BeforeLoginUI()
}
