import SwiftUI

struct FilterViewAcedemician: View {
    @Binding var selectedUniversity: String
    @Binding var selectedProvince: String
    @Binding var selectedKeywords: String
    
    var iller: [String]
    var universiteler: [String]
    var anahtarKelimeler: [String]

    @State private var searchUniversity: String = ""
    @State private var searchProvince: String = ""
    @State private var searchKeywords: String = ""
    
    @State private var showUniversityDropdown: Bool = false
    @State private var showProvinceDropdown: Bool = false
    @State private var showKeywordsDropdown: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            // Üniversite arama ve seçme
            VStack(alignment: .leading) {
                HStack {
                    TextField("Üniversite Ara", text: $searchUniversity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            showUniversityDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showUniversityDropdown ? 180 : 0))
                    }
                }
                .padding(.horizontal)
                
                if showUniversityDropdown {
                    List(filteredUniversities, id: \.self) { university in
                        Button(action: {
                            selectedUniversity = university
                            searchUniversity = university
                            showUniversityDropdown = false
                        }) {
                            Text(university)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // İl arama ve seçme
            VStack(alignment: .leading) {
                HStack {
                    TextField("İl Ara", text: $searchProvince)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            showProvinceDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showProvinceDropdown ? 180 : 0))
                    }
                }
                .padding(.horizontal)
                
                if showProvinceDropdown {
                    List(filteredProvinces, id: \.self) { province in
                        Button(action: {
                            selectedProvince = province
                            searchProvince = province
                            showProvinceDropdown = false
                        }) {
                            Text(province)
                        }
                    }
                    .frame(maxHeight: 150)
                }
            }
            .padding()

            // Anahtar kelimeler arama ve seçme
            VStack(alignment: .leading) {
                HStack {
                    TextField("Anahtar Kelimeler Ara", text: $searchKeywords)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation {
                            showKeywordsDropdown.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(showKeywordsDropdown ? 180 : 0))
                    }
                }
                .padding(.horizontal)
                
                if showKeywordsDropdown {
                    List(filteredKeywords, id: \.self) { keyword in
                        Button(action: {
                            selectedKeywords = keyword
                            searchKeywords = keyword
                            showKeywordsDropdown = false
                        }) {
                            Text(keyword)
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
    
    // Filtrelenmiş üniversiteler
    var filteredUniversities: [String] {
        if searchUniversity.isEmpty {
            return universiteler
        } else {
            return universiteler.filter { $0.localizedCaseInsensitiveContains(searchUniversity) }
        }
    }

    // Filtrelenmiş iller
    var filteredProvinces: [String] {
        if searchProvince.isEmpty {
            return iller
        } else {
            return iller.filter { $0.localizedCaseInsensitiveContains(searchProvince) }
        }
    }

    // Filtrelenmiş anahtar kelimeler
    var filteredKeywords: [String] {
        if searchKeywords.isEmpty {
            return anahtarKelimeler
        } else {
            return anahtarKelimeler.filter { $0.localizedCaseInsensitiveContains(searchKeywords) }
        }
    }
}
