//
//  SwiftUIView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//
import SwiftUI

struct PictureDialogView: View {
    let folderPath:String
    @StateObject var imgManager:ImageManager
    var body: some View {
        VStack {
            Spacer()
            Text("image source")
            Text("choose your image source".localized)
            Spacer()
            Button(action: {
                if imgManager.check(){
                    imgManager.sourceType = .camera
                    imgManager.showImagePicker = true
                }
                else {
                    imgManager.beyondLimitAlert = true
                }
            }, label: {
                Text("camera".localized)
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                if imgManager.check(){
                    imgManager.sourceType = .photoLibrary
                    imgManager.showImagePicker = true
                }
                else{
                    imgManager.beyondLimitAlert = true
                }
                
            }, label: {
                Text("Image Library".localized)
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
            Button(action: {
                imgManager.showPictureDialog = false
            }, label: {
                Text("confirm".localized)
            })
                .frame(width: UIScreen.main.bounds.width/2, height: 30)
                .border(Color.gray, width: 1)
        }
        .sheet(isPresented: $imgManager.showImagePicker) {
            ImagePicker(folderPath: folderPath,imgManager: imgManager,sourceType: imgManager.sourceType)
        }
        .alert("at most 5 picture".localized, isPresented: $imgManager.beyondLimitAlert, actions: {
            Text("OK".localized)
        })
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
