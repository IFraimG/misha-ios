
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Binding var isAuthenticated: Bool
    
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    var body: some View {
//                Button(action: {
//                    logout()
//                }) {
//                    Text("Покинуть MISHA")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }

        FoldersListView(title: .constant("Misha"), isActiveNav: .constant(true), onItemClick: .constant(nil))
        
        Spacer()
            
        Button(action: {
            PopupFolderView().showAndStack()
        }) {
            Text("Добавить папку")
                .frame(maxWidth: .infinity)
                .padding()
                    .background(Color.black.opacity(0.05))
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .cornerRadius(10)
            }.padding(.horizontal, 20).padding(.top, 20)
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        isAuthenticated = false
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true))
}
