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
            row(title: "name", instruction: "請輸入名稱")
            row(title: "longitude", instruction: "點擊定位取的所在位置")
            row(title: "latitude", instruction: "點擊定位取的所在位置")
            row(title: "keyword", instruction: "請輸入景點關鍵字")
            row(title: "format", instruction: "All")
            row(title: "group", instruction: "屬於自己")
            row(title: "description", instruction: "請輸入景點描述內容")
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
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .foregroundColor(.orange)
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            switch(title) {
            case "description":
                TextEditor(text: $text)
                    .frame(height: 200)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
            case "group":
                groupPicker()
            case "format":
                formatPicker()
            default:
                TextField(instruction, text: $text)
                    .textFieldStyle(.roundedBorder)
            }
            
        }
        .padding()
    }
}
struct groupPicker:View {
    @State private var text:String = ""
    var body: some View {
        TextField("",text: $text)
            .textFieldStyle(.roundedBorder)
    }
}
struct formatPicker:View {
    @State private var text:String = "屬於自己"
    @State private var selection:Int = 0
    @State private var pickerClick:Bool = false
    var formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]
    var body: some View {
        VStack {
            TextField("",text:$text)
                .textFieldStyle(.roundedBorder)
//                .disabled(true)
                .onTapGesture {
                    pickerClick = true
                }
                
            if pickerClick {
                Picker(selection: $selection) {
                    ForEach(formats.indices) { item in
                        Button {
                            text = formats[item]
                            
                        } label: {
                            Text(formats[item])
                        }
                    }
                } label: {
                    Text("test")
                }
                .pickerStyle(.wheel)
                .frame(width: UIScreen.main.bounds.width,height: 150)
                .background(Color.white)
                .cornerRadius(12)
                .clipped()
            }
        }
    }
}
struct PicturePOI_Previews: PreviewProvider {
    static var previews: some View {
        POIView(type: "picture")
    }
}
