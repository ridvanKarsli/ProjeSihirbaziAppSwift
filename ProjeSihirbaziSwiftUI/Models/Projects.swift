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

}

