
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
    
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        isAuthenticated = false
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true))
}
