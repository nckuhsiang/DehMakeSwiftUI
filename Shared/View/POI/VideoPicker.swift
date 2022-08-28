//
//  VideoPicker.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/26.
//

import UIKit
import SwiftUI
import AVFoundation
import MobileCoreServices
struct VideoPicker: UIViewControllerRepresentable {
    let folderPath:String
    @Environment(\.presentationMode) var isPresented
    @StateObject var videoManager:VideoManager
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [UTType.movie.identifier]
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> VCoordinator {
        return VCoordinator(picker: self)
    }
    
    
}

class VCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: VideoPicker
    init(picker: VideoPicker) {
        self.picker = picker
    }
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedVideo: URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            let isSaved = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(selectedVideo.path)
            if isSaved{
                UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.path, self, nil, nil)
            }
            //store vedio into DEH-Make folder
            let timestamp = Int(NSDate().timeIntervalSince1970)
            self.picker.videoManager.videoPath = self.picker.folderPath + "/Video_" + timestamp.description + ".mov"
            let videoData = NSData(contentsOf: selectedVideo)
            videoData?.write(toFile: self.picker.videoManager.videoPath, atomically: true)
        }
        self.picker.videoManager.videoText = "play video"
        self.picker.isPresented.wrappedValue.dismiss()
    }

}
