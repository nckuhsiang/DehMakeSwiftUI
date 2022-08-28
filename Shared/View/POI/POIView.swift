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


let formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]

struct POIView: View {
    
    let type:mediaType
    @State var folderPath = ""
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var isPresented
    @State var title:String = ""
    @State var format:String = "All"
    @State var keyword:String = ""
    @State var group:String = "Me"
    @State var description:String = ""
    @State var longitude:String = ""
    @State var latitude:String = ""
    
    @StateObject var location:LocationManager = LocationManager()
    @StateObject var speakRecorder: AudioRecorder = AudioRecorder()
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    @StateObject var imgManager:ImageManager = ImageManager()
    @StateObject var videoManager:VideoManager = VideoManager()
    
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
                        PoiPickerRow(title: "format".localized,data: formats, selected:$format)
                        PoiPickerRow(title: "group".localized,data: gvm.groups_name, selected:$group)
                        if speakRecorder.showAudio == true {
                            HStack {
                                Button (action: {
                                    speakRecorder.execRecord(folderPath: folderPath)
                                }, label: {
                                    Text(speakRecorder.audioText)
                                        .frame(width: UIScreen.main.bounds.width-30,height: 30)
                                        .background(speakRecorder.color)
                                        .foregroundColor(.white)
                                })
                            }
                            .padding()
                        }
                        
                        switch type {
                        case .image:
                            Text("picture preview".localized)
                                .font(.system(size: 25))
                                .padding()
                            ForEach(imgManager.images) { img in
                                Image(uiImage: img.image)
                                    .resizable()
                                    .scaledToFit()
                            }
                        case .audio:
                            if audioRecorder.showAudio == true {
                                HStack {
                                    Button (action: {
                                        audioRecorder.execRecord(folderPath: folderPath)
                                    }, label: {
                                        Text(audioRecorder.audioText)
                                            .frame(width: UIScreen.main.bounds.width-30,height: 30)
                                            .background(audioRecorder.color)
                                            .foregroundColor(.white)
                                    })
                                }
                                .padding()
                            }
                        case .video:
                            if videoManager.showVideoButton == true {
                                HStack {
                                    Button (action: {
                                        if videoManager.videoPath == "" {
                                            videoManager.showVideoPicker = true
                                        }
                                        else {
                                            videoManager.playVideo = true
                                        }
                                    }, label: {
                                        Text(videoManager.videoText)
                                            .frame(width: UIScreen.main.bounds.width-30,height: 30)
                                            .background(.blue)
                                            .foregroundColor(.white)
                                    })
                                }
                                .padding()
                                .sheet(isPresented: $videoManager.playVideo, content: {
                                    AVPlayerView(videoURL: videoManager.videoPath)
                                })
                                
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        location.getLocation()
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
                            imgManager.showPictureDialog = true
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
                        addPoi()
                    }, label: {
                        Image("download")
                    })
                    
                    Spacer()
                }
                .padding(.top)
                .background(.orange)
                
            }
            if imgManager.showPictureDialog {
                PictureDialogView(folderPath: folderPath,imgManager: imgManager)
            }
        }
        
        .sheet(isPresented: $videoManager.showVideoPicker) {
            VideoPicker(folderPath:folderPath, videoManager: videoManager)
        }
        
        .onAppear {
            folderPath = createFolder()
            gvm.getGroupNameList(id: uvm.id, coi: uvm.coi, language: language)
        }
        
    }
}
extension POIView {
    func createFolder() -> String {
        print("DEH Folder Creating")
        let fileManager1 = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPaths = (documentsDirectory as! NSString).appendingPathComponent("DEH-Image")
        var folderPath = ""
        if fileManager1.fileExists(atPath: dataPaths){
            print("Folder already exist!")
            folderPath = dataPaths
            print("Following is DEH photo path : ")
            print(folderPath)  ///var/mobile/Containers/Data/Application/5D894EEA-04BD-4AB9-A2F8-12D32711AFD4/Documents/DEH-Image
        }
        else{
            do {
                try FileManager.default.createDirectory(atPath: dataPaths, withIntermediateDirectories: false, attributes: nil)
                folderPath = dataPaths
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return folderPath
    }
    private func check() -> Bool {
        print(title,description,keyword,location.address,imgManager.imageUrls.count)
        if title == "" || description == "" || keyword == "" || location.address == ""  {
            return false
        }
        switch type {
        case .image:
            if imgManager.imageUrls.count == 0 {
                return false
            }
        case .audio:
            if audioRecorder.audioPath == "" {
                return false
            }
        case .video:
            if(videoManager.videoPath == ""){
                return false
            }
        }
        return true
    }
    private func addPoi() {
        if check() {
            let poi = Poi(context: viewContext)
            poi.title = title
            poi.keyword = keyword
            poi.longitude = location.longitude
            poi.latitude = location.latitude
            poi.address = location.address
            poi.summary = description
            poi.format = format
            poi.identifier = uvm.role
            poi.language = language
            poi.coi = uvm.coi
            poi.group = (group == "Me".localized ? "" : group)
            
            //意義不明的欄位
            poi.id = 0
            poi.height = "0"
            poi.source = ""
            poi.rights = ""
            poi.open = 1
            poi.subject = "Activation and Reconstructed"
            poi.type = "Natural Landscape"
            poi.year = 2022
            poi.period = ""
            switch type {
            case .image:
                poi.media_type = "Image"
            case .audio:
                poi.media_type = "Audio"
            case .video:
                poi.media_type = "Vedio"
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            self.isPresented.wrappedValue.dismiss()
        }
    }
    
}
struct PicturePOI_Previews: PreviewProvider {
    static var previews: some View {
        POIView(type: mediaType.image).environmentObject(UserViewModel())
    }
}

