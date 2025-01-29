import SwiftUI

struct FilterViewProject: View {
    @Binding var selectedKurum: String
    @Binding var selectedSektor: String
    @Binding var selectedName: String
    @Binding var selectedDurum: String
    @Binding var selectedSiralama: String
    
    var kurumlar: [String] = []
    var sektorler: [String] = []
    var basvuruDurumlari: [String] = []
    var siralamalar: [String] = []
    
    @State private var searchKurum: String = ""
    @State private var searchSektor: String = ""
    @State private var showKurumDropdown: Bool = false
    @State private var showSektorDropdown: Bool = false
    @State private var showDurumDropdown: Bool = false
    @State private var showSiralamaDropdown: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
       
    
    var body: some View {
        VStack {
            // Kurum arama ve seçme
            VStack(alignment: .leading) {
                HStack {
                    TextField("Kurum Ara", text: $searchKurum)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            showKurumDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showKurumDropdown ? 180 : 0))
                    }
                }
                .padding(.horizontal)
                
                if showKurumDropdown {
                    List(filteredKurumlar, id: \.self) { kurum in
                        Button(action: {
                            selectedKurum = kurum
                            searchKurum = kurum
                            showKurumDropdown = false
                        }) {
                            Text(kurum)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // Sektör arama ve seçme
            VStack(alignment: .leading) {
                HStack {
                    TextField("Sektör Ara", text: $searchSektor)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            showSektorDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showSektorDropdown ? 180 : 0))
                    }
                }
                .padding(.horizontal)
                
                if showSektorDropdown {
                    List(filteredSektorler, id: \.self) { sektor in
                        Button(action: {
                            selectedSektor = sektor
                            searchSektor = sektor
                            showSektorDropdown = false
                        }) {
                            Text(sektor)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // Başvuru durumu seçme
            VStack(alignment: .leading) {
                HStack {
                    Text(selectedDurum.isEmpty ? "Başvuru Durumu Seçin" : selectedDurum)
                        .foregroundColor(selectedDurum.isEmpty ? .gray : .primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        .onTapGesture {
                            withAnimation {
                                showDurumDropdown.toggle()
                            }
                        }
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showDurumDropdown ? 180 : 0))
                        .onTapGesture {
                            withAnimation {
                                showDurumDropdown.toggle()
                            }
                        }
                }
                .padding(.horizontal)
                
                if showDurumDropdown {
                    List(basvuruDurumlari, id: \.self) { durum in
                        Button(action: {
                            selectedDurum = durum
                            showDurumDropdown = false
                        }) {
                            Text(durum)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // Sıralama seçme
            VStack(alignment: .leading) {
                HStack {
                    Text(selectedSiralama.isEmpty ? "Sıralama Seçin" : selectedSiralama)
                        .foregroundColor(selectedSiralama.isEmpty ? .gray : .primary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        .onTapGesture {
                            withAnimation {
                                showSiralamaDropdown.toggle()
                            }
                        }
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showSiralamaDropdown ? 180 : 0))
                        .onTapGesture {
                            withAnimation {
                                showSiralamaDropdown.toggle()
                            }
                        }
                }
                .padding(.horizontal)
                
                if showSiralamaDropdown {
                    List(siralamalar, id: \.self) { siralama in
                        Button(action: {
                            selectedSiralama = siralama
                            showSiralamaDropdown = false
                        }) {
                            Text(siralama)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // Uygula Butonu
            Button("Uygula") {
                // Filtreleme işlemi burada yapılacak
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
    }
    
    // Filtrelenmiş kurumlar
    var filteredKurumlar: [String] {
        if searchKurum.isEmpty {
            return kurumlar
        } else {
            return kurumlar.filter { $0.localizedCaseInsensitiveContains(searchKurum) }
        }
    }

    // Filtrelenmiş sektörler
    var filteredSektorler: [String] {
        if searchSektor.isEmpty {
            return sektorler
        } else {
            return sektorler.filter { $0.localizedCaseInsensitiveContains(searchSektor) }
        }
    }
}
