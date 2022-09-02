//
//  AudioRecorder.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
//https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

enum AudioState {
    case record
    case stop_record
    case play
    case stop_play
}

class AudioRecorder: ObservableObject {
    
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    @Published var audioText:String = "開始錄音"
    @Published var color:Color = .blue
    @Published var showAudio:Bool = false
    @Published var audioPath:String?
    @Published var recording:AudioState = .record
    
    
    func execRecord(folderPath:String){
        switch recording {
        case .record:
            startRecord(folderPath)
        case .stop_record:
            stopRecord()
        case .play:
            playRecord(folderPath)
        case .stop_play:
            stopPlayRecord()
        }
    }
    func startRecord( _ folderPath:String) {
        let recordingSession = AVAudioSession.sharedInstance()
        // 設置 session 類型
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch let err {
            print("類型設置失敗:\(err)")
        }
        
        // 錄音設置
        let setting: [String: Any] = [
            AVFormatIDKey:Int(kAudioFormatMPEG4AAC),                                // 音頻格式
            AVSampleRateKey: NSNumber(value: 16000),                                // 採樣率
            AVLinearPCMBitDepthKey: NSNumber(value: 16),                            // 采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),                              // 通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue), // 錄音質量
        ];
        let timestamp = Int(NSDate().timeIntervalSince1970)
        audioPath =  "/Record_" + timestamp.description + ".aac"
        do {
            let url = URL(fileURLWithPath: folderPath + audioPath!)
            audioRecorder = try AVAudioRecorder(url: url, settings: setting)
            audioRecorder.record()
            recording = .stop_record
            audioText = "停止錄音"
            color = .red
        } catch {
            print("Could not start recording")
        }
        
    }
    func stopRecord() {
        audioRecorder.stop()
        recording = .play
        audioText = "開始播放"
        color = .blue
    }
    func playRecord( _ folderPath:String) {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: folderPath + audioPath!))
            print("歌曲長度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失敗:\(err.localizedDescription)")
        }
        recording = .stop_play
        audioText = "停止播放"
        color = .red
    }
    func stopPlayRecord(){
        player!.stop()
        recording = .play
        audioText = "開始播放"
        color = .blue
    }
    
    func initial(path:String){
        audioText = "開始播放"
        recording = .play
        showAudio = true
        audioPath = path
    }
}
