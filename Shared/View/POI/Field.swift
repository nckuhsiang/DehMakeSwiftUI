//
//  Field.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import SwiftUI

struct PoiTextRow:View {
    let title:String
    let instruction:String
    @Binding var text:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            
            TextField(instruction, text: $text)
                .textFieldStyle(.roundedBorder)
                .onTapGesture {
                    UIApplication.dismissKeyboard()
                }
                
        }
        .padding()
    }
}
struct PoiReadOnlyRow:View {
    let title:String
    let instruction:String
    @Binding var text:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            
            Text(text == "" ? instruction:text)
                .frame(width: 220,height: 30,alignment: .leading)
                .cornerRadius(25)
                .border(.gray, width: 1)
                .font(.system(size: 16))
                
        }
        .padding()
    }
}
struct PoiPickerRow:View {
    
    let title:String
    let data:[String]
    @Binding var selected:String
    @State var index:Int = 0
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            Picker(selection: $index) {
                ForEach(0 ..< data.count,id: \.self){ i in
                    Button(action: {
                        selected = data[i]
                    }, label: {
                        Text(data[i]).tag(i)
                    })
                    
                }
            } label: {
                Text("test")
            }
            
        }
        .padding()
    }
}
struct PoiEditorRow:View {
    
    let title:String
    @Binding var text:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            TextEditor(text: $text)
                .frame(width: 220, height: 150)
                .cornerRadius(25)
                .border(.gray, width: 1)
                .onTapGesture {
                    UIApplication.dismissKeyboard()
                }
            
        }
        .padding()
    }
}

struct Field_Previews: PreviewProvider {
    static var previews: some View {
        PoiEditorRow(title: "name",text: .constant(""))
    }
}
