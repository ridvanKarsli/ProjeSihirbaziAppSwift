import Foundation

struct ProjeSihirbaziAI: Codable {
    var id: Int
    var userId: Int
    var chatHistoryJson: String
    var createdDateTime: String
    var lastDateTime: String
    var model: String
    
    init(id: Int, userId: Int, chatHistoryJson: String, createdDateTime: String, lastDateTime: String, model: String) {
        self.id = id
        self.userId = userId
        self.chatHistoryJson = chatHistoryJson
        self.createdDateTime = createdDateTime
        self.lastDateTime = lastDateTime
        self.model = model
    }
    
        func getId() -> Int {
           return self.id
       }

       func getUserId() -> Int {
           return self.userId
       }

       func getChatHistoryJson() -> String {
           return self.chatHistoryJson
       }

       func getCreatedDateTime() -> String {
           return self.createdDateTime
       }

       func getLastDateTime() -> String {
           return self.lastDateTime
       }

       func getModel() -> String {
           return self.model
       }

        

}

