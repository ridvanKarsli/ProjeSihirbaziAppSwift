import SwiftUI
struct ProjectsUI: View {

    var filtreDataAccess = FiltreManager()
    let projectsType: String
    
    @State private var projectsArr: [Projects] = []
    @State private var kurumlar: [String] = []
    @State private var sektorler: [String] = []
    @State private var basvuruDurumlari = ["Açık", "Yakında Açılacaklar", "Sürekli Açık"]
    @State private var siralamalar = ["Tarihe göre(Artan)", "Tarihe göre(Azalan)", "Ada göre(A-Z)", "Ada göre(Z-A)"]
    
    @State private var basvuruDurumlariAPI = ["AÇIK", "YAKINDA_AÇILACAK", "SÜREKLİ_AÇIK"]
    @State private var siralamalarAPI = ["date_desc", "date_asc", "name_asc", "name_desc"]
    
    @State private var currentPage = 1
    @State private var selectedAd: String = ""
    @State private var selectedSiralama: String = ""
    @State private var selectedKurum: String = ""
    @State private var selectedSektor: String = ""
    @State private var selectedDurum: String = ""
    @State private var isLoading: Bool = false
    @State private var totalPages: Int = 1
    @State private var showFilterSheet: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        TextField("Ad Ara", text: $selectedAd)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: selectedAd, { _, _ in
                                getProject()
                            })
                        
                        // Proje Listesi
                        if isLoading {
                            ProgressView("Yükleniyor...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else {
                            LazyVStack {
                                ForEach(projectsArr) { project in
                                    ProjectRow(project: project, projectsType: projectsType)
                                }
                            }
                            .refreshable {
                                refreshData()
                            }
                        }
                        
                    }
                }
                
                // Sayfa Değiştirme
                HStack {
                    Button(action: {
                        if currentPage > 1 {
                            currentPage -= 1
                            getProject()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(currentPage > 1 ? .blue : .gray)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(currentPage <= 1)
                    
                    Spacer()
                    
                    Text("Sayfa \(currentPage) / \(totalPages)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < totalPages {
                            currentPage += 1
                            getProject()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(currentPage < totalPages ? .blue : .gray)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(currentPage >= totalPages)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle(projectsType)
            .navigationBarItems(trailing: Button("Filtreler") {
                showFilterSheet.toggle() // Filtreler sheet'ini göster
            })
            .onAppear {
                getProject()
                getSektorler()
                getKurumlar(tur: projectsType)
                performTokenRefresh()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterViewProject(
                    selectedKurum: $selectedKurum,
                    selectedSektor: $selectedSektor,
                    selectedName: $selectedAd,
                    selectedDurum: $selectedDurum,
                    selectedSiralama: $selectedSiralama,
                    kurumlar: kurumlar,
                    sektorler: sektorler,
                    basvuruDurumlari: basvuruDurumlari,
                    siralamalar: siralamalar
                )
                .onDisappear {
                    getProject() // Filtreleme işlemi bitince projeleri güncelle
                }
            }
        }
        
    }
    
    func refreshData() {
        getProject()
    }

    func getProject() {
        let projectDataAccess = ProjectManager()
        // Seçilen durum ve sıralamaya karşılık gelen API değerlerini al
        let durumIndex = basvuruDurumlari.firstIndex(of: selectedDurum)
        let siralamaIndex = siralamalar.firstIndex(of: selectedSiralama)
        
        let durumAPIValue = durumIndex != nil ? basvuruDurumlariAPI[durumIndex!] : ""
        let siralamaAPIValue = siralamaIndex != nil ? siralamalarAPI[siralamaIndex!] : ""
        
        
        
        // Yükleniyor durumu
        isLoading = true
        
        // API isteği
        projectDataAccess.getProject(
            tur: projectsType,
            page: currentPage,
            sector: selectedSektor,
            search: selectedAd,
            status: durumAPIValue, // Seçilen durumun API değeri
            company: selectedKurum,
            sortOrder: siralamaAPIValue // Seçilen sıralamanın API değeri
        ) { projevts, totalPages, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Hata durumunda
                    self.isLoading = false
                    self.showAlert(message: error)
                } else if let projects = projevts, let totalPages = totalPages {
                    // Başarılı veri alımı durumunda
                    self.projectsArr = projects
                    self.totalPages = totalPages
                    self.isLoading = false
                }
            }
        }
    }


    func getKurumlar(tur: String) {
        filtreDataAccess.getKurumlar(tur: tur) { kurumlar in
            DispatchQueue.main.async {
                self.kurumlar = kurumlar
            }
        }
    }

    func getSektorler() {
        filtreDataAccess.getSektorler { sektorler in
            DispatchQueue.main.async {
                self.sektorler = sektorler
            }
        }
    }
    
    func showAlert(message: String) {
        // Alert gösterme fonksiyonu
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = keyWindow.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func performTokenRefresh() {
        let userDataAccess = UserDataAccess()
        userDataAccess.refreshToken { success in
            if success {
                print("Token başarıyla yenilendi.")
                
            } else {
                print("Token yenileme başarısız.")
                
            }
        }
    }


}



struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsUI(projectsType: "İhale")
    }
}


#Preview {
    ProjectsUI(projectsType: "İhale")
}
