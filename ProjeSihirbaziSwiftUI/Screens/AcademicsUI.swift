import SwiftUI

struct AcademicsUI: View {
    let filtreDataAccess = FiltreManager()
    
    @State private var currentPage = 1
    @State private var selectedName = ""
    @State private var selectedProvince = ""
    @State private var selectedUniversity = ""
    @State private var selectedKeywords = ""
    @State private var academicsArr: [Academician] = []
    @State private var isRefreshing = false
    @State private var iller: [String] = []
    @State private var universiteler: [String] = []
    @State private var anahtarKelimeler: [String] = []
    @State private var isLoading: Bool = false
    @State private var showFilterSheet = false
    @State private var totalPages = 1 // Toplam sayfa sayısı

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView{
                    VStack(alignment: .leading) {
                        TextField("Ad Ara", text: $selectedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .onChange(of: selectedName, { _, _ in
                                getAcademics()
                            })
                        
                        if isLoading {
                            ProgressView("Yükleniyor...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else {
                            LazyVStack {
                                ForEach(academicsArr, id: \.name) { academician in
                                    AcademicianRow(academician: academician)
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
                            getAcademics()
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
                            getAcademics()
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
            .navigationBarTitle("Akademisyenler")
            .navigationBarItems(trailing: Button("Filtreler") {
                showFilterSheet.toggle()  // Filtreler sheet'ini göster
            })
            .onAppear {
                getAcademics()
                getIl()
                getUni()
                getKeyword()
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterViewAcedemician(selectedUniversity: $selectedUniversity, selectedProvince: $selectedProvince, selectedKeywords: $selectedKeywords, iller: iller, universiteler: universiteler, anahtarKelimeler: anahtarKelimeler)
                    .onDisappear {
                        getAcademics()  // Filtreleme işlemi bitince akademisyenleri güncelle
                    }
            }
        }
    }
    
    func refreshData() {
        getAcademics()
    }

    func getAcademics() {
        let academicianDataAccess = AcademicianManager()
        isLoading = true
        // getAcademics fonksiyonunu çağırıyoruz
        academicianDataAccess.getAcademics(currentPage: currentPage,
                                  selectedName: selectedName,
                                  selectedProvince: selectedProvince,
                                  selectedUniversity: selectedUniversity,
                                  selectedKeywords: selectedKeywords) { academics, error, totalPages in
            // Hata kontrolü
            if let error = error {
                isLoading = false
                self.showAlert(message: error)
            } else if let academics = academics {
                isLoading = false
                // Akademisyenler başarıyla alındı, verileri güncelliyoruz
                self.academicsArr = academics
                // Toplam sayfa sayısını alıyoruz
                self.totalPages = totalPages!
            }
        }
    }

    func getIl() {
        filtreDataAccess.getIl { iller in
            DispatchQueue.main.async {
                self.iller = iller
            }
        }
    }

    func getUni() {
        filtreDataAccess.getUni { universities in
            DispatchQueue.main.async {
                self.universiteler = universities
            }
        }
    }

    func getKeyword() {
        filtreDataAccess.getKeyword { keys in
            DispatchQueue.main.async {
                self.anahtarKelimeler = keys
            }
        }
    }

    func showAlert(message: String) {
        // Hata mesajını gösterecek bir çözüm
        // Örneğin bir alert ekleyebilirsiniz
        print("Hata: \(message)") // Örnek hata gösterimi
    }
}

struct AcademicsView_Previews: PreviewProvider {
    static var previews: some View {
        AcademicsUI()
    }
}

#Preview {
    AcademicsUI()
}
