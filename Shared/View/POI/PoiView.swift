//
//  PicturePOI.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/27.
//
//import CoreLocationUI
import SwiftUI
import Alamofire
import Combine
import AVFoundation
import CryptoKit




struct PoiView: View {
    @State var formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]
    @State var type:mediaType
    var poi:FetchedResults<Poi>.Element?
    
    @State var fieldErrorAlert = false
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var isPresented
    @StateObject var location:LocationManager = LocationManager()
    @StateObject var speakRecorder: AudioRecorder = AudioRecorder()
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    @StateObject var imgManager:ImageManager = ImageManager()
    @StateObject var videoManager:VideoManager = VideoManager()
    @State var title:String = ""
    @State var format:String = "All"
    @State var keyword:String = ""
    @State var group:String = "Me"
    @State var description:String = ""
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        PoiTextRow(title: "title".localized, instruction: "input your title".localized,text: $title)
                        PoiTextRow(title: "keyword".localized, instruction: "input the poi keyword".localized,text: $keyword)
                        PoiReadOnlyRow(title: "longitude".localized, instruction: "click button to get your location".localized,text: $location.longitude)
                        PoiReadOnlyRow(title: "latitude".localized, instruction: "click button to get your location".localized,text: $location.latitude)
                        PoiEditorRow(title: "description".localized,text: $description)
                        PoiPickerRow(title: "format".localized,data: $formats, selected:$format)
                        PoiPickerRow(title: "group".localized,data: $gvm.groups_name, selected:$group)
                        if speakRecorder.showAudio == true {
                            HStack {
                                Button (action: {
                                    speakRecorder.execRecord(folderPath: uvm.folderPath)
                                    
                                }, label: {
                                    Text(speakRecorder.audioText)
                                        .frame(width: UIScreen.main.bounds.width-50,height: 30)
                                        .background(speakRecorder.color)
                                        .foregroundColor(.white)
                                })
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        deleteMedia(format: 8)
                                    }
                            }
                            .padding()
                        }
                        
                        switch type {
                        case .image:
                            HStack {
                                Text("picture preview".localized)
                                    .font(.system(size: 25))
                                    .padding()
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        deleteMedia(format: 1)
                                    }
                            }
                            
                            ForEach(imgManager.imageUrls ?? [],id: \.self) { path in
                                Image(uiImage: UIImage(contentsOfFile: uvm.folderPath+path) ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                            }
                        case .audio:
                            if audioRecorder.showAudio == true {
                                HStack {
                                    Button (action: {
                                        audioRecorder.execRecord(folderPath: uvm.folderPath)
                                        
                                    }, label: {
                                        Text(audioRecorder.audioText)
                                            .frame(width: UIScreen.main.bounds.width-50,height: 30)
                                            .background(audioRecorder.color)
                                            .foregroundColor(.white)
                                    })
                                    Image(systemName: "trash")
                                        .onTapGesture {
                                            deleteMedia(format: 2)
                                        }
                                }
                                .padding()
                            }
                        case .video:
                            if videoManager.showVideoButton == true {
                                HStack {
                                    Button (action: {
                                        if videoManager.videoPath == nil {
                                            videoManager.showVideoPicker = true
                                        }
                                        else {
                                            videoManager.playVideo = true
                                        }
                                    }, label: {
                                        Text(videoManager.videoText)
                                            .frame(width: UIScreen.main.bounds.width-50,height: 30)
                                            .background(.blue)
                                            .foregroundColor(.white)
                                    })
                                    Image(systemName: "trash")
                                        .onTapGesture {
                                            deleteMedia(format: 4)
                                        }
                                }
                                .padding()
                                .sheet(isPresented: $videoManager.playVideo, content: {
                                    AVPlayerView(videoURL: uvm.folderPath + videoManager.videoPath!)
                                })
                                
                            }
                            
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        location.getLocation() { addr in
                            location.address = addr
                            location.latitude = location.latitude
                            location.longitude = location.longitude
                        }
                    }, label: {
                        Image("placeholder")
                            .alert("complete to get your location".localized, isPresented: $location.showCompleteAlert, actions: {
                                Text("OK".localized)
                            })
                    })
                    Spacer()
                    switch type {
                    case .image:
                        Button(action: {
                            imgManager.showPictureDialog.toggle()
                        }, label: {
                            Image("picture")
                        })
                    case .audio:
                        Button(action: {
                            audioRecorder.showAudio = true
                        }, label: {
                            Image("speaker")
                        })
                    case .video:
                        Button(action: {
                            videoManager.showVideoButton = true
                        }, label: {
                            Image("video-player")
                        })
                    }
                    
                    
                    Spacer()
                    Button(action: {
                        speakRecorder.showAudio = true
                    }, label: {
                        Image("microphone")
                    })
                    
                    Spacer()
                    Button(action: {
                        updatePoi()
                    }, label: {
                        Image("download")
                    })
                    
                    Spacer()
                }
                .padding(.top)
                .background(.orange)
            }
            if imgManager.showPictureDialog {
                PictureDialogView(folderPath: uvm.folderPath, imgManager: imgManager)
            }
        }
        .alert( "please fill and upload all information".localized, isPresented: $fieldErrorAlert, actions: {
            Text("OK".localized)
        })
        .sheet(isPresented: $videoManager.showVideoPicker) {
            VideoPicker(folderPath: uvm.folderPath, videoManager: videoManager)
        }
        
        .onAppear {
            initial()
        }
        
    }
}

//struct PicturePOI_Previews: PreviewProvider {
//    static var previews: some View {
//        POIView(type: mediaType.image).environmentObject(UserViewModel())
//    }
//}

