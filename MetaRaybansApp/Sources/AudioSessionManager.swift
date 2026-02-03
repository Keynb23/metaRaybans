import AVFoundation

class AudioSessionManager {
    
    // Step 7: Audio Handling
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure for playAndRecord and allowBluetooth for HFP
            try session.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.allowBluetooth, .defaultToSpeaker]
            )
            
            // Activate the session
            try session.setActive(true)
            
            print("AVAudioSession configured successfully for HFP.")
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }
    
    func deactivateAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate AVAudioSession: \(error)")
        }
    }
}
