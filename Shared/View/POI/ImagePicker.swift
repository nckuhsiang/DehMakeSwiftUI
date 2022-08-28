//
//  ImagePocker.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//


import UIKit
import SwiftUI
import AVFoundation

struct ImagePicker: UIViewControllerRepresentable {
    
    let folderPath:String
    @StateObject var imgManager:ImageManager
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> CCoordinator {
        return CCoordinator(picker: self)
    }
}

class CCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePicker
    init(picker: ImagePicker) {
        self.picker = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
//        let imageToSave : NSData = UIImageJPEGRepresentation(selectedImage, 0.8)! as NSData
        let imageToSave : NSData = selectedImage.jpegData(compressionQuality: 0.8)! as NSData
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let imagePath = self.picker.folderPath + "/IMG_" + timestamp.description + ".jpg"
        print("Image Path : " + imagePath)
        imageToSave.write(toFile: imagePath, atomically: true)
        self.picker.imgManager.images.append(ImageItem(image: selectedImage))
        self.picker.imgManager.imageUrls.append(imagePath)
        self.picker.isPresented.wrappedValue.dismiss()
        
        
        
    }

}
