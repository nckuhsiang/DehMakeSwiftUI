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

let formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]

struct POIView: View {
    
    let type:mediaType
    @State var folderPath:String = ""
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @StateObject var pvm:PoiViewModel = PoiViewModel()
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    @StateObject var image:ImageManager = ImageManager()
    @StateObject var location:LocationManager = LocationManager()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        PoiTextRow(title: "name", instruction: "請輸入名稱",text: $pvm.name)
                        PoiTextRow(title: "longitude", instruction: "點擊定位取的所在位置",text: $location.longitude)
                        PoiTextRow(title: "latitude", instruction: "點擊定位取的所在位置",text: $location.latitude)
                        PoiTextRow(title: "keyword", instruction: "請輸入景點關鍵字",text: $pvm.keyword)
                        PoiEditorRow(title: "description",text: $pvm.description)
                        PoiPickerRow(title: "format",data: formats, selected:$pvm.format)
                        PoiPickerRow(title: "group",data: gvm.groups_name, selected:$pvm.group)
                        if audioRecorder.showAudio == true {
                            HStack {
                                Button (action: {
                                    audioRecorder.execRecord()
                                }, label: {
                                    Text(audioRecorder.audioText)
                                        .frame(width: UIScreen.main.bounds.width-30,height: 30)
                                        .background(audioRecorder.color)
                                        .foregroundColor(.white)
                                    
                                })
                            }
                            .padding()
                        }
                        
                        Text("picture preview")
                            .font(.system(size: 25))
                            .padding()
                        Image(uiImage: image.image ?? UIImage())
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 500)
                        
                        //                        Spacer()
                    }
                }
                Spacer()
                TabButton(type:type,location: location, image: image, audioRecorder: audioRecorder)
                
            }
            if image.showPictureDialog {
                PictureDialogView(imagePoi: image)
            }
        }
        .alert("complete to get your location ", isPresented: $pvm.showLocationAlert) {
            Text("OK")
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
}
//    func getGroupList(){
//        test = ["Me"]
//        let url = GroupGetUserGroupListUrl
//        let parameters = [
//            "user_id": "\(setting.id)",
//            "coi_name": setting.coi,
//            "language": language,
//        ]
//        AF.request(url,method: .post,parameters: parameters).responseDecodable(of: GroupLists.self) { response in
//            print(tmp)
//            for group in tmp {
//                test.append(group.name)
//            }
//        }
//        let publisher = AF.request(url, method: .post, parameters: parameters)
//            .publishDecodable(type: GroupLists.self, queue: .main)
//        self.cancellable = publisher
//            .sink(receiveValue: {(values) in
//                let tmp = values.value?.results ?? []
//                tmp.forEach({ group in
//                    test.append(group.name)
//                })
//            })
//        print(test)
//    } 
//}



struct PicturePOI_Previews: PreviewProvider {
    static var previews: some View {
        POIView(type: mediaType.image).environmentObject(UserViewModel())
    }
}

