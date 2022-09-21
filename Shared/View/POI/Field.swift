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
                .frame(width: UIScreen.main.bounds.width/2)
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
                .frame(width: UIScreen.main.bounds.width/2,height: 30,alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
                .font(.system(size: 16))
                
        }
        .padding()
    }
}
struct PoiPickerRow:View {
    
    let title:String
    @Binding var data:[String]
    @Binding var selected:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            Picker(selection: $selected) {
                ForEach(data,id: \.self){
                    Text($0)
                }
            } label: {
                Text("You selected: \(selected)")
            }
            .frame(width: UIScreen.main.bounds.width/2)
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
                .frame(width: UIScreen.main.bounds.width/2, height: 150)
                .cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
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
