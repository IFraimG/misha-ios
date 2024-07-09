import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: UserViewModel
    
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            if isAuthenticated {
                if viewModel.url != nil {
                    ChooseFolderView(viewModel: viewModel)
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
    ContentView(viewModel: UserViewModel(), isAuthenticated: .constant(false))
}
