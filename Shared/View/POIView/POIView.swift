//
//  PicturePOI.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/27.
//

import SwiftUI

struct POIView: View {
    let type:String
//    @State private var name:String = ""
//    @State private var longitude:String = ""
//    @State private var latitude:String = ""
//    @State private var format:String = ""
//    @State private var keyword:String = ""
//    @State private var group:String = ""
//    @State private var description:String = ""
    var body: some View {
        VStack(alignment: .leading){
            row(title: "name:", instruction: "請輸入名稱")
            row(title: "longitude:", instruction: "點擊定位取的所在位置")
            row(title: "latitude:", instruction: "點擊定位取的所在位置")
            row(title: "keyword:", instruction: "請輸入景點關鍵字")
            row(title: "format:", instruction: "All")
            row(title: "group:", instruction: "屬於自己")
            row(title: "description:", instruction: "請輸入景點描述內容")
            Text("picture preview")
                .foregroundColor(.orange)
                .font(.system(size: 25))
                .padding()
            Spacer()
            HStack {
                Spacer()
                Image("placeholder")
                Spacer()
                Image(type)
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
}

struct row:View{
    let title:String
    let instruction:String
    @State private var text:String = ""
    init(title:String,instruction:String) {
        self.title = title
        self.instruction = instruction
    }
    var body: some View {
        HStack(spacing:30) {
            Text(title)
                .foregroundColor(.orange)
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            TextField(instruction, text: $text)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

struct PicturePOI_Previews: PreviewProvider {
    static var previews: some View {
        POIView(type: "picture")
    }
}
