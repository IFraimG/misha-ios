
import SwiftUI
import SwiftData

@main
struct mishaApp: App {
    @State private var isAuthenticated = false
    
    @State private var showLaunchScreen = true
    
    @State private var url: URL?
    
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
                ContentView(isAuthenticated: $isAuthenticated, url: $url).modelContainer(for: UserData.self).implementPopupView()
                    .onOpenURL { url in
                        self.url = url
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
    
//    private func handleOpenURL(_ url: URL) {
//        if isAuthenticated {
//            
//        }
//    }
}
