import SwiftUI

struct DropoffPhotoView: View {
    let order: Order
    @Environment(\.dismiss) private var dismiss
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var isUploading = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Take Delivery Photo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Please take a clear photo of where you left the order")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                } else {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera.fill")
                                .font(.largeTitle)
                            Text("Take Photo")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                
                if image != nil {
                    Button(action: {
                        uploadPhoto()
                    }) {
                        HStack {
                            Text("Complete Delivery")
                                .fontWeight(.semibold)
                            if isUploading {
                                ProgressView()
                                    .tint(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    .disabled(isUploading)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    private func uploadPhoto() {
        isUploading = true
        // Simulate upload
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isUploading = false
            dismiss()
        }
    }
}

// Add this struct for camera access
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
} 