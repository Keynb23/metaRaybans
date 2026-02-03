import SwiftUI
import Wearables

@main
struct MetaRaybansApp: App {
    @StateObject private var wearablesManager = WearablesManager()
    
    init() {
        // Step 3: Initialization
        // Configure the SDK on application launch
        Wearables.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(wearablesManager)
                .onOpenURL { url in
                    // Step 4: handleUrl(url:)
                    // Handle the deep link back from Meta AI app during registration
                    wearablesManager.handleUrl(url: url)
                }
        }
    }
}
