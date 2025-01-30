import Foundation
import UIKit

// Akademisyen modelini tanımlıyoruz.
class Academician: Codable, Identifiable  {
    var title: String
    var name: String
    var section: String
    var keywords: String
    var imageUrl: String
    var university: String
    var province: String
    
    // Constructor (initializer)
    init(title: String, name: String, section: String, keywords: String, imageUrl: String, university: String, province: String) {
        self.title = title
        self.name = name
        self.section = section
        self.keywords = keywords
        self.imageUrl = imageUrl
        self.university = university
        self.province = province
    }
    
    // Getter metodları
    func getTitle() -> String {
        return self.title
    }

    func getName() -> String {
        return self.name
    }

    func getSection() -> String {
        return self.section
    }

    func getKeywords() -> String {
        return self.keywords
    }

    func getImageUrl() -> String {
        return self.imageUrl
    }

    func getUniversity() -> String {
        return self.university
    }

    func getProvince() -> String {
        return self.province
    }

}
