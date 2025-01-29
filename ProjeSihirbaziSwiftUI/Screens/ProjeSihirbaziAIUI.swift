import SwiftUI

struct ProjeSihirbaziAIUI: View {
    let projectId: Int
    
    @State private var messageText: String = ""
    @State private var chat: [ChatMessage] = []
    @State private var chatId: Int = 0
    @State private var token: String = ""
    @State private var isRefreshing: Bool = false
    @State private var chats: [ProjeSihirbaziAI] = [] // Eski sohbetler
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showOldChats = false  // Eski sohbetler ekranını kontrol eden bayrak
    
    var body: some View {
        VStack {
            // Mesaj listesi
            List {
                ForEach(chat, id: \.id) { chatMessage in
                    HStack {
                        if chatMessage.sender == "user" {
                            Spacer()
                        }
                        
                        Text(chatMessage.text)
                            .padding()
                            .background(chatMessage.sender == "user" ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        if chatMessage.sender != "user" {
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }
            }
            .refreshable {
                refreshData()
            }
            
            // Mesaj yazma ve gönderme kısmı
            HStack {
                TextField("Mesajınızı giriniz", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                    .frame(height: 45)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                Button(action: sendMessageClicked) {
                    Text("Gönder")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .onAppear {
            print("project id: \(projectId)")
            if chatId != 0 {
                if let token = UserDefaults.standard.string(forKey: "accessToken") {
                    self.token = token
                    getChatWithId(token: token, id: chatId)
                }
            }
        }
        .navigationTitle("Sohbet")
        .navigationBarItems(trailing: Button("Sohbetler") {
            self.showOldChats.toggle()  // Eski sohbetler ekranını aç
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                self.token = token
                getOldChats(token: token)  // Eski sohbetleri al
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showOldChats) {  // Eski sohbetlerin gösterildiği modal ekran
            VStack {
                Text("Eski Sohbetler")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                List {
                    ForEach(chats, id: \.id) { chat in
                        Text("Chat \(chat.getCreatedDateTime())")
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .onTapGesture {
                                self.chatId = chat.getId()
                                getChatWithId(token: token, id: chatId)  // Seçilen sohbeti yükle
                                self.showOldChats = false  // Eski sohbetler ekranını kapat
                            }
                    }
                    .onDelete(perform: deleteChat)
                }
                
                Button("Yeni Sohbet Oluştur") {
                    createNewChat()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding()
                .shadow(radius: 5)
            }
        }
        .padding(.top)
    }
    
    private func createNewChat() {
        let psAi = ProjeSihirbaziAI(id: 0, userId: 0, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "")
        
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            psAi.createNewChat(projectId: projectId, token: token) { chat in
                if let chat = chat {
                    DispatchQueue.main.async {
                        self.chatId = chat.getId()
                        UserDefaults.standard.set(self.chatId, forKey: "selectedChatId")
                        self.sendMessage(token: token)
                        self.showOldChats = false  // Yeni sohbet oluşturulduğunda eski sohbetler ekranını kapat
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to create a new chat."
                        self.showAlert = true
                    }
                }
            }
        }
    }

    private func sendMessageClicked() {
        // Mesajın boş olmadığından emin olun
        guard !messageText.isEmpty else {
            return // Boş mesaj gönderilmesini engelle
        }
        
        // Mesajı gönder
        askToAI()
        
    }

    private func askToAI() {
        let psAi = ProjeSihirbaziAI(id: 0, userId: 0, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "")
        
        if chatId == 0 {
            // Yeni sohbet oluşturulmamışsa
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                psAi.createNewChat(projectId: projectId, token: token) { chat in
                    if let chat = chat {
                        DispatchQueue.main.async {
                            self.chatId = chat.getId()
                            UserDefaults.standard.set(self.chatId, forKey: "selectedChatId")
                            self.sendMessage(token: token)
                        }
                    }
                }
            }
        } else {
            // Mevcut sohbeti güncelle
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                sendMessage(token: token)
            }
        }
    }

    private func sendMessage(token: String) {
        let psAi = ProjeSihirbaziAI(id: 0, userId: 0, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "")
        
        // Mesajı gönder
        psAi.sendMessage(chatId: chatId, message: messageText, token: token)
        // Bu satır ile chat dizisini güncelle, sayfa kendiliğinden yenilenecek
        getChatWithId(token: token, id: chatId)  // Yeni mesajları al ve chat dizisini güncelle
        
        // Klavyeyi kapat
        dismissKeyboard()
        
        // Mesajı sıfırla
        messageText = ""
    }
    
    private func dismissKeyboard() {
        // UIKit ile klavyeyi gizle
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first(where: { $0.isKeyWindow }) {
                window.endEditing(true)
            }
        }
    }


    private func getChatWithId(token: String, id: Int) {

        let projeSihirbaziAI = ProjeSihirbaziAI(id: 1, userId: 1, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "")
        projeSihirbaziAI.getChatWithId(projectId: projectId, chatId: id, token: token) { chatWithId in
            if let chat = chatWithId {
                DispatchQueue.main.async {
                    self.chat = chat
                    print("Received response: \(chat)")
                }
            }
        }
    }
    
    private func getOldChats(token: String) {
        ProjeSihirbaziAI(id: 0, userId: 0, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "").getOldChat(projectId: projectId, token: token) { chat in
            if let chat = chat {
                DispatchQueue.main.async {
                    self.chats = chat  // Eski sohbetler listesini güncelle
                }
            }
        }
    }
    
    private func deleteChat(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let chat = chats[index]
        
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            ProjeSihirbaziAI(id: 0, userId: 0, chatHistoryJson: "", createdDateTime: "", lastDateTime: "", model: "").deleteChat(token: token, chatId: chat.getId()) { success in
                DispatchQueue.main.async {
                    if success {
                        // Diziden kaldır
                        self.chats.remove(at: index)
                    } else {
                        // Silme başarısızsa kullanıcıya mesaj göster
                        self.alertMessage = "Sohbet silinemedi"
                        self.showAlert = true
                    }
                }
            }
        }
    }

    private func refreshData() {
        if let selectedChatIdUserDefaul = UserDefaults.standard.value(forKey: "selectedChatId") as? Int {
            chatId = selectedChatIdUserDefaul
        }
        
        if chatId != 0 {
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                self.token = token
                chat.removeAll() // Eski mesajları temizle
                getChatWithId(token: token, id: chatId)  // Yeni mesajları al
            }
        }
    }
}

struct ProjeSihirbaziAIView_Previews: PreviewProvider {
    static var previews: some View {
        ProjeSihirbaziAIUI(projectId: 90914)
            .preferredColorScheme(.dark) // Dark mode desteği
    }
}

#Preview {
    ProjeSihirbaziAIUI(projectId: 90914)
}
