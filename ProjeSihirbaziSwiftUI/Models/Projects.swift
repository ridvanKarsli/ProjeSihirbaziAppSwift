import Foundation

// Projeleri temsil eden sınıf
class Projects: Codable, Identifiable {
    
    var id: Int                 // Projenin benzersiz ID'si
    var ad: String              // Projenin adı
    var resim: String           // Projeye ait görsel URL'si
    var kurum: String           // Projeyi sunan kurumun adı
    var basvuruDurumu: String   // Başvuru durumu (örneğin: "Açık", "Kapalı")
    var basvuruLinki: String    // Başvuru bağlantısı
    var sektorler: String       // Projenin ait olduğu sektörler (örneğin: "Teknoloji", "Sağlık")
    var eklenmeTarihi: String   // Projeye ait eklenme tarihi
    var tur: String             // Proje türü (örneğin: "Hibe", "Destek")

    // Initializer (Yapıcı metod)
    init(id: Int, ad: String, resim: String, kurum: String, basvuruDurumu: String, basvuruLinki: String, sektorler: String, eklenmeTarihi: String, tur: String) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kurum = kurum
        self.basvuruDurumu = basvuruDurumu
        self.basvuruLinki = basvuruLinki
        self.sektorler = sektorler
        self.eklenmeTarihi = eklenmeTarihi
        self.tur = tur
    }
    
    // Getter metodlar
    func getId() -> Int { return id }
    func getResim() -> String { return resim }
    func getAd() -> String { return ad }
    func getKurum() -> String { return kurum }
    func getEklenmeTarihi() -> String { return eklenmeTarihi }
    func getBasvuruDurumu() -> String { return basvuruDurumu }
    func getBasvuruLinki() -> String { return basvuruLinki }
    func getSektorler() -> String { return sektorler }
    
    // API'den projeleri çeken fonksiyon
    func getProject(tur: String, page: Int, sector: String, search: String, status: String, company: String, sortOrder: String, completion: @escaping ([Projects]?, Int?, String?) -> Void) {
        let urlString = APIEndpoints.getProjectURL(tur: tur, page: page, sector: sector, search: search, status: status, company: company, sortOrder: sortOrder)

        guard let url = URL(string: urlString) else {
            completion(nil, nil, "Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, nil, "No data received")
                return
            }
            
            do {
                // ResponseProject üzerinden yanıt çözümleme
                let response = try JSONDecoder().decode(ResponseProject.self, from: data)
                // Projeleri ve toplam sayfa sayısını döndürme
                completion(response.items, response.totalPages, nil)
            } catch {
                completion(nil, nil, "Error decoding data")
            }
        }
        
        task.resume()
    }
}

// API'den dönen JSON yanıtındaki verileri modelleyen yapı
struct ResponseProject: Codable {
    let currentPage: Int       // Şu anki sayfa numarası
    let pageSize: Int          // Sayfa başına öğe sayısı
    let totalItems: Int        // Toplam öğe sayısı
    let totalPages: Int        // Toplam sayfa sayısı
    let items: [Projects]      // Projelerin listesi
}
