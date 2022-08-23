//
//  SwiftUIView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//
import SwiftUI

struct PictureDialogView: View {
    @StateObject var imagePoi:ImageManager
    var body: some View {
        VStack {
            Spacer()
            Text("影像來源")
            Text("請選擇選取方式")
            Spacer()
            Button(action: {
                imagePoi.sourceType = .camera
                imagePoi.showImagePicker = true
            }, label: {
                Text("相機")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                imagePoi.sourceType = .photoLibrary
                imagePoi.showImagePicker = true
            }, label: {
                Text("相片庫")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                imagePoi.showPictureDialog = false
            }, label: {
                Text("確定")
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
        }
        .sheet(isPresented: $imagePoi.showImagePicker) {
            ImagePicker(selectedImage: self.$imagePoi.image,sourceType: imagePoi.sourceType)
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
