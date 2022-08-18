//
//  Field.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import SwiftUI

struct Field:View {
    let title:String
    let instruction:String
    @Binding var text:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .foregroundColor(.orange)
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

struct Field_Previews: PreviewProvider {
    static var previews: some View {
        Field(title: "name", instruction: "enter your name", text: .constant(""))
    }
}
