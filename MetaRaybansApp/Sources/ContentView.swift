import SwiftUI
import Wearables

struct ContentView: View {
    @EnvironmentObject var wearablesManager: WearablesManager
    @StateObject private var streamViewModel = StreamViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                statusHeader
                
                if !wearablesManager.isRegistered {
                    registrationButton
                } else if let device = wearablesManager.connectedDevice {
                    streamView(for: device)
                } else {
                    deviceDiscoveryList
                }
                
                Spacer()
                
                aiResponseFooter
            }
            .padding()
            .navigationTitle("AI Glasses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if wearablesManager.isRegistered && wearablesManager.connectedDevice != nil {
                        Button(streamViewModel.isStreaming ? "Stop" : "Stream") {
                            if streamViewModel.isStreaming {
                                streamViewModel.stopStreaming()
                            } else if let device = wearablesManager.connectedDevice {
                                streamViewModel.startStreaming(for: device)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var statusHeader: some View {
        HStack {
            Circle()
                .fill(wearablesManager.isRegistered ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(wearablesManager.isRegistered ? "Registered" : "Not Registered")
                .font(.caption)
            
            Spacer()
            
            if let device = wearablesManager.connectedDevice {
                Text(device.name)
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    var registrationButton: some View {
        VStack {
            Text("Connect your Ray-Ban Meta glasses to start using the custom AI agent.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                wearablesManager.startRegistration()
            }) {
                Text("Start Registration")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    var deviceDiscoveryList: some View {
        VStack {
            Text("Searching for devices...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // In a real app, this would be a list of discovered devices
            Button("Connect to Ray-Ban Meta") {
                // Mock selection
                wearablesManager.requestCameraPermission()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    func streamView(for device: WearableDevice) -> some View {
        VStack {
            if let frame = streamViewModel.lastFrame {
                Image(uiImage: frame)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.8))
                        .frame(height: 300)
                    
                    if streamViewModel.isStreaming {
                        ProgressView("Waiting for frames...")
                            .foregroundColor(.white)
                    } else {
                        Text("Stream Inactive")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    var aiResponseFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Custom AI Insight:")
                .font(.headline)
            
            ScrollView {
                Text(streamViewModel.aiResponse.isEmpty ? "No data yet." : streamViewModel.aiResponse)
                    .font(.body)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 100)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            if streamViewModel.isProcessing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Thinking...")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
