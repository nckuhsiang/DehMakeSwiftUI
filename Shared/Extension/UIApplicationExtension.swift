//
//  UIApplicationExtension.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func dismissKeyboard() {
        let keyWindow = shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}
