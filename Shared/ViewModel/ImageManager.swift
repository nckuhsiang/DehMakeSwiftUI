//
//  ImageViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation
import UIKit

class ImageManager: ObservableObject,Identifiable{
    @Published var images:[ImageItem] = []
    @Published var imageUrls:[String] = []
    @Published var showPictureDialog:Bool = false
    @Published var showImagePicker:Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var beyondLimitAlert:Bool = false
    func check() -> Bool {
        if images.count >= 5 {
            return false
        }
        return true
    }
}



