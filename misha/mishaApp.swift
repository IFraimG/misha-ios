
import SwiftUI
import SwiftData

@main
struct mishaApp: App {
    @State private var isAuthenticated = false
    
    @State private var showLaunchScreen = true
    
    @StateObject private var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup() {
            if showLaunchScreen {
                LaunchScreenView().onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showLaunchScreen = false
                        checkAuthentication()
                    }
                }
            } else {
                ContentView(viewModel: userViewModel, isAuthenticated: $isAuthenticated).modelContainer(for: UserData.self).implementPopupView()
                    .onOpenURL { url in
                        userViewModel.setUrlForLink(url: url)
                    }
            }
        }
    }
    
    private func checkAuthentication() {
        if let storedToken = UserDefaults.standard.string(forKey: "token"), !storedToken.isEmpty {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}
