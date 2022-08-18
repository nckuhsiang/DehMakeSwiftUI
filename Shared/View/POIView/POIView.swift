//
//  PicturePOI.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/27.
//
//import CoreLocationUI
import SwiftUI
import CoreLocation
import Alamofire
import Combine
struct POIView: View {
    let type:String
    @EnvironmentObject var setting:SettingStore
    @State private var cancellable: AnyCancellable?
    //location
    //Image
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isImagePickerDisplay = false
    @StateObject var pvm:POIViewModel = POIViewModel()

    @State private var alertState:Bool = false
    @State private var pickerState:Bool = false
    @State private var sheetState:Bool = false
    let formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Field(title: "name", instruction: "請輸入名稱",text: $pvm.name)
                        Field(title: "longitude", instruction: "點擊定位取的所在位置",text: $pvm.longitude)
                        Field(title: "latitude", instruction: "點擊定位取的所在位置",text: $pvm.latitude)
                        Field(title: "keyword", instruction: "請輸入景點關鍵字",text: $pvm.keyword)
//                        PickerSelector(title: "format", instruction: "All",state: $pickerState,data:$pickerData, text: $format)
//                        PickerSelector(title: "group", instruction: "屬於自己",state: $pickerState, data:$pickerData, text: $group)
//                        Editor(title: "description",text: $description)
                        Text("picture preview")
                            .foregroundColor(.orange)
                            .font(.system(size: 25))
                            .padding()
                        Image(uiImage: pvm.image ?? UIImage())
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                        
                        Spacer()
                    }
                }
                Spacer()
                TabButton(pvm:pvm)
                
            }
            
            if pvm.showPictureDialog {
                PictureDialogView(pvm: pvm)
            }
        }
        .alert("complete to get your location ", isPresented: $pvm.showAlert) {
            Text("OK")
        }
        
        
    }
    
    
}





struct PicturePOI_Previews: PreviewProvider {
    static var previews: some View {
        POIView(type: "picture").environmentObject(SettingStore())
    }
}

