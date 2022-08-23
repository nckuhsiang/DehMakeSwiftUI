//
//  ImageViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation
import UIKit

class ImageManager: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var showPictureDialog:Bool = false
    @Published var showImagePicker:Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
}
