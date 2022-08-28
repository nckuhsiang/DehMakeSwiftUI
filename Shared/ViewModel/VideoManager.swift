//
//  VideoManager.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/26.
//

import Foundation
import AVFoundation
import UIKit
import AVKit

class VideoManager: ObservableObject {
    @Published var showVideoPicker:Bool = false
    @Published var showVideoButton:Bool = false
    @Published var videoText:String = "start record movie"
    @Published var videoPath:String = ""
    @Published var playVideo:Bool = false
}
