import Foundation
import MWDATCore
import MWDATCamera
import Combine
import UIKit
import AVFoundation

@MainActor
class StreamViewModel: ObservableObject {
    @Published var isStreaming: Bool = false
    @Published var lastFrame: UIImage?
    @Published var aiResponse: String = ""
    @Published var isProcessing: Bool = false
    
    private var streamSession: StreamSession?
    private var cancellables = Set<AnyCancellable>()
    private let aiService = CustomAIService()
    private let audioManager = AudioSessionManager()
    
    func startStreaming(for device: WearableDevice) {
        // Step 1: Initialize HFP before starting stream (Requirement)
        audioManager.setupAudioSession()
        
        // Step 2: Configure Stream Session
        // Requirement: low resolution (360 x 640) and 24 FPS
        let config = StreamConfiguration(
            resolution: .low, // 360 x 640
            fps: 24
        )
        
        do {
            streamSession = try device.createStreamSession(configuration: config)
            
            // Step 3: Listen to video frames
            streamSession?.videoFramePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] frame in
                    self?.processFrame(frame)
                }
                .store(in: &cancellables)
            
            streamSession?.statePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    self?.isStreaming = (state == .streaming)
                    print("Stream state changed: \(state)")
                }
                .store(in: &cancellables)
            
            // Start the session
            streamSession?.start()
            
        } catch {
            print("Failed to start streaming: \(error)")
        }
    }
    
    func stopStreaming() {
        guard let session = streamSession else { return }
        
        // Constraint: Check state before restarting or stopping if needed
        // but here we just want to stop/close.
        session.stop()
        streamSession = nil
    }
    
    private func processFrame(_ frame: VideoFrame) {
        // Convert VideoFrame to UIImage for UI and AI processing
        guard let uiImage = frame.asUIImage() else { return }
        self.lastFrame = uiImage
        
        // Step 6: Custom AI Agent Integration
        // Only send frame if not already processing
        if !isProcessing {
            sendToAI(uiImage)
        }
    }
    
    private func sendToAI(_ image: UIImage) {
        isProcessing = true
        
        Task {
            do {
                let response = try await aiService.analyzeImage(image)
                self.aiResponse = response
                
                // Feedback loop: optionally play response as audio
                // audioManager.speak(response)
                
            } catch {
                print("AI Service Error: \(error)")
                self.aiResponse = "Error: \(error.localizedDescription)"
            }
            self.isProcessing = false
        }
    }
}

// Extension to help conversion (Mocked implementation)
extension VideoFrame {
    func asUIImage() -> UIImage? {
        // In real SDK, this would convert the pixel buffer/buffer to UIImage
        return UIImage(pixelBuffer: self.pixelBuffer)
    }
}
