import SwiftUI

struct MainMenuUI: View {
    
    //variables
    @State private var grantCount: Int = 0
    @State private var academicianCount: Int = 0
    @State private var tenderCount: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showProfileSheet: Bool = false
    
    @State private var isToHibe: Bool = false
    @State private var isToAcademic: Bool = false
    @State private var isToIhale: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                
                // hibe button
                Button(action: {
                    isToHibe = true
                }) {
                    MenuButton(title: "Hibe: \(grantCount)", iconName: "doc.text.fill", color: .blue)
                }
                .navigationDestination(isPresented: $isToHibe) {
                    ProjectsUI(projectsType: "Hibe")
                }
                
                //acadamic button
                Button(action: {
                    isToAcademic = true
                }) {
                    MenuButton(title: "Akademisyen: \(academicianCount)", iconName: "person.fill", color: .green)
                }
                .navigationDestination(isPresented: $isToAcademic) {
                    AcademicsUI()
                }
                
                //Ihale
                Button(action: {
                    isToIhale = true
                }) {
                    MenuButton(title: "İhale: \(tenderCount)", iconName: "doc.text.fill", color: .purple)
                }
                .navigationDestination(isPresented: $isToIhale) {
                    ProjectsUI(projectsType: "İhale")
                }
                
            }
            .padding()
            .onAppear {
                UserDefaults.standard.set(0, forKey: "selectedChatId")
                getDashboardData()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Uyarı"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
            
            // Profil butonu
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showProfileSheet.toggle()
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileUI()
        }
        .navigationBarHidden(true) // Navigation bar tamamen gizlendi
    }

    func getDashboardData() {
        let dashboard = Dashboard(grantCount: 0, academicianCount: 0, tenderCount: 0)
        
        dashboard.getDashboardData { fetchedDashboard in
            DispatchQueue.main.async {
                if let dashboard = fetchedDashboard {
                    self.grantCount = dashboard.getGrantCount()
                    self.academicianCount = dashboard.getAcademicianCount()
                    self.tenderCount = dashboard.getTenderCount()
                } else {
                    self.alertMessage = "Veriler alınamadı. Lütfen tekrar deneyin."
                    self.showAlert = true
                }
            }
        }
    }
    


}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuUI()
    }
}

#Preview {
    MainMenuUI()
}
