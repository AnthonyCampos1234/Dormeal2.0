import SwiftUI
import PhotosUI

struct DropoffPhotoView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    let orderId: String
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var photoUrl: String?
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Take a photo of where you left the order")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                if let photoUrl = photoUrl {
                    AsyncImage(url: URL(string: photoUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                PhotosPicker(selection: $selectedItem,
                           matching: .images,
                           photoLibrary: .shared()) {
                    Label("Take Photo", systemImage: "camera")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                if photoUrl != nil {
                    Button(action: {
                        showingConfirmation = true
                    }) {
                        Text("Confirm Dropoff")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .navigationTitle("Dropoff Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Confirm Dropoff", isPresented: $showingConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm", role: .destructive) {
                    if let photoUrl = photoUrl {
                        Task {
                            await appState.markOrderAsDroppedOff(orderId: orderId, photoUrl: photoUrl)
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("Please confirm you've dropped off the order and taken a photo of the dropoff location")
            }
            .onChange(of: selectedItem) { _ in
                Task {
                    // Here you would normally upload the photo and get back a URL
                    // For now, we'll simulate it
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    photoUrl = "https://example.com/mock-photo.jpg"
                }
            }
        }
    }
} 