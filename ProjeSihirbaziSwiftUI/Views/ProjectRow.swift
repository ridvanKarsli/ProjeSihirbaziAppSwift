import SwiftUI

struct ProjectRow: View {
    var project: Projects
    var projectsType: String
    @State private var navigateToAIWizard = false

    var body: some View {
        VStack(alignment: .center) {
            // Resmi gösteriyoruz
            let imageName = project.getResim()
            let imageURL = URL(string: "https://projesihirbaziapi.enmdigital.com/" + imageName)
            
            if let validImageURL = imageURL {
                AsyncImage(url: validImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView() // Resim yüklenirken gösterilecek
                }
            } else {
                Text("Geçersiz resim URL'si")
                    .foregroundColor(.red)
            }

            // Diğer içerik...
            VStack(alignment: .leading) {
                Text(project.getAd())
                    .font(.headline)
                    .lineLimit(3)
                    .truncationMode(.tail)
                Text(project.getKurum())
                    .font(.subheadline)
                    .lineLimit(1)
                Text(project.getEklenmeTarihi())
                    .font(.caption)
                    .lineLimit(1)
                Text(project.getBasvuruDurumu())
                    .font(.body)
                Text(project.getSektorler())
                    .font(.body)
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .leading)

            if projectsType == "Hibe"{
                Button(action: {
                    navigateToAIWizard = true
                }) {
                    Text("Yapay Zeka ile Konuş")
                        .font(.body)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
                .navigationDestination(isPresented: $navigateToAIWizard) {
                    ProjeSihirbaziAIUI(projectId: project.getId())
                }
            }
        }
        .padding()
        .onTapGesture {
            if let url = URL(string: project.getBasvuruLinki()) {
                UIApplication.shared.open(url)
            }
        }
    }
}
