//
//  Editor.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import SwiftUI

struct Editor:View {
    let title:String
    @Binding var text:String
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            Text(title + ":")
                .foregroundColor(.orange)
                .frame(width: 150,alignment: .leading)
                .font(.system(size: 25))
            TextEditor(text: $text)
                .frame(height: 200)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
                .onTapGesture {
                    UIApplication.dismissKeyboard()
                }
        }
        .padding()
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor(title: "description", text: .constant(""))
    }
}
