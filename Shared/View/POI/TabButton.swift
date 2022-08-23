//
//  TabButton.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//

import SwiftUI
import CoreLocation
import AVFAudio
struct TabButton: View {
    
    let type:mediaType
    @StateObject var location:LocationManager
    @StateObject var image:ImageManager
    @StateObject var audioRecorder:AudioRecorder
    
    var body: some View {
            HStack {
                Spacer()
                Button(action: {
                    location.getLocation()
                }, label: {
                    Image("placeholder")
                        .alert("定位完成", isPresented: $location.showCompleteAlert, actions: {
                            Text("OK")
                        })
                })
                Spacer()
                switch type {
                case .image:
                    Button(action: {
                        image.showPictureDialog = true
                    }, label: {
                        Image("picture")
                    })
                case .audio:
                    Button(action: {
                    }, label: {
                        Image("speaker")
                    })
                case .video:
                    Button(action: {
                    }, label: {
                        Image("video-player")
                    })
                }
                
                
                Spacer()
                Button(action: {
                    audioRecorder.showAudio = true
                    
                }, label: {
                    Image("microphone")
                })
                
                Spacer()
                Image("download")
                Spacer()
            }
            .padding(.top)
            .background(.orange)
            
        
        
    }
}
extension TabButton {
    
    
}

//struct TabButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TabButton()
//    }
//}
