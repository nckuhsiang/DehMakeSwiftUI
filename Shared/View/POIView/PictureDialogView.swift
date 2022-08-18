//
//  SwiftUIView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//
import SwiftUI

struct PictureDialogView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplay = false
    @StateObject var pvm:POIViewModel
    var body: some View {
        VStack {
            Spacer()
            Text("影像來源")
            Text("請選擇選取方式")
            Spacer()
            Button(action: {
                self.sourceType = .camera
                self.isImagePickerDisplay = true
//                poi_info.showPictureDialog = false
            }, label: {
                Text("相機")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay = true
//                poi_info.showPictureDialog = false
            }, label: {
                Text("相片庫")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                pvm.showPictureDialog = false
            }, label: {
                Text("取消")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePicker(selectedImage: self.$pvm.image, sourceType: self.sourceType)
        }
        .frame(minWidth: nil, idealWidth: nil, maxWidth: UIScreen.main.bounds.width/2, minHeight: nil, idealHeight: nil, maxHeight: 150, alignment: .center)
        .padding()
        .border(Color.black,width: 1)
        .background(.white)
    }
}

//struct PictureDialogView_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureDialogView()
//    }
//}
