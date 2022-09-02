//
//  ImageViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation
import UIKit

class ImageManager: ObservableObject,Identifiable{
    @Published var imageUrls:[String]?
    @Published var showPictureDialog:Bool = false
    @Published var showImagePicker:Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var beyondLimitAlert:Bool = false
    func check(imageCount:Int) -> Bool {
        if imageCount >= 5 {
            return false
        }
        return true
    }
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
}



