//
//  TabButton.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/18.
//

import SwiftUI

struct TabButton: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var pvm:POIViewModel
    var body: some View {
            HStack {
                Spacer()
                Image("placeholder")
                Spacer()
                Button(action: {
                    pvm.showPictureDialog = true
                }, label: {
                    Image("picture")
                })
                
                Spacer()
                Image("microphone")
                Spacer()
                Image("download")
                Spacer()
            }
            .padding(.top)
            .background(.orange)
            
        
        
    }
}

//struct TabButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TabButton()
//    }
//}
