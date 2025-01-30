import Foundation
import UIKit

class User {
    
    // Kullanıcı bilgilerini saklayan private değişkenler
    private var id: Int
    private var name: String
    private var surname: String
    private var email: String
    private var phone: String
    private var imageFile: String?
    private var role: String
    
    // Yapıcı fonksiyon (Initializer)
    init(id: Int, name: String, surname: String, email: String, phone: String, imageFile: String, role: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.phone = phone
        self.imageFile = imageFile
        self.role = role
    }
    
    // Kullanıcı bilgilerine erişim sağlayan getter fonksiyonları
    func getId() -> Int { return id }
    func getName() -> String { return name }
    func getSurname() -> String { return surname }
    func getEmail() -> String { return email }
    func getPhone() -> String { return phone }
    func getImageFile() -> String? { return imageFile }
    func getRole() -> String { return role }
}


