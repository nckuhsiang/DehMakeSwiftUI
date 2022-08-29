//
//  File.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/26.
//

import Foundation
import SwiftUI
import UIKit
import AVKit

struct AVPlayerView: UIViewControllerRepresentable {

    var videoURL: String

    private var player: AVPlayer {
        let url = URL(fileURLWithPath: videoURL)
        return AVPlayer(url: url)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
