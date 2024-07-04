
import SwiftUI

@main
struct mishaApp: App {
    @State private var showLaunchScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView().onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showLaunchScreen = false
                    }
                }
            } else {
                ContentView()
            }
        }
    }
}
