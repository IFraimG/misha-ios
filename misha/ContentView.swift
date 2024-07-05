import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            if isAuthenticated {
                HomeView(isAuthenticated: $isAuthenticated)
            } else {
                AuthView(isAuthenticated: $isAuthenticated)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(isAuthenticated: .constant(false))
}
