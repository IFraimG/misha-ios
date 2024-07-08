import SwiftUI
import SwiftData

struct ContentView: View {
    @Binding var isAuthenticated: Bool
    @Binding var url: URL?
    
    var body: some View {
        VStack {
            if isAuthenticated {
                if url != nil {
                    ChooseFolderView(url: $url)
                } else {
                    HomeView(isAuthenticated: $isAuthenticated)
                }
            } else {
                AuthView(isAuthenticated: $isAuthenticated)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(isAuthenticated: .constant(false), url: .constant(nil))
}
