//
//  ImageDeneme.swift
//  TextMyDiary
//
//  Created by can ersoz on 3.01.2021.
//
/*
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var url: NSURL?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker

    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.image = uiImage
            parent.url = info[.imageURL] as! NSURL
                
            print("image")
            }

            parent.presentationMode.wrappedValue.dismiss()
    }
}

struct ImageDeneme: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var url: NSURL?
    var body: some View {
        NavigationView {
            VStack {
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Tap to select a picture")
                        .font(.headline)
                }
                
                Button(action: {
                    showingImagePicker = true
                }){
                    Text("Tap me")
                }
            }.navigationBarTitle("Hello")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, url: self.$url)
            }
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return print("error") }
        image = Image(uiImage: inputImage)
    }
}

struct ImageDeneme_Previews: PreviewProvider {
    static var previews: some View {
        ImageDeneme()
    }
}
*/
