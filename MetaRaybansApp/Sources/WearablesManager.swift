import Foundation
import MWDATCore
import Combine

class WearablesManager: ObservableObject {
    @Published var isRegistered: Bool = false
    @Published var connectedDevice: WearableDevice?
    @Published var cameraPermissionStatus: WearablesPermissionStatus = .notDetermined
    
    private let wearables = Wearables.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // Monitor device availability
        wearables.devicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.connectedDevice = device
            }
            .store(in: &cancellables)
            
        // Monitor registration state
        wearables.registrationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.isRegistered = state == .registered
            }
            .store(in: &cancellables)
    }
    
    // Step 4: Registration & Permissions
    func startRegistration() {
        wearables.startRegistration()
    }
    
    func handleUrl(url: URL) {
        // Meta AI deep link handling
        wearables.handleUrl(url)
    }
    
    func requestCameraPermission() {
        wearables.requestPermission(.camera) { [weak self] status in
            DispatchQueue.main.async {
                self?.cameraPermissionStatus = status
            }
        }
    }
    
    func connectDevice(_ device: WearableDevice) {
        wearables.connect(device)
    }
}
