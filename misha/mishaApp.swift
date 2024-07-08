
import SwiftUI
import SwiftData

@main
struct mishaApp: App {
    @State private var isAuthenticated = false
    
    @State private var showLaunchScreen = true
    
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
                ContentView(isAuthenticated: $isAuthenticated).modelContainer(for: UserData.self).implementPopupView()
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
