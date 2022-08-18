//
//  Picker.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import SwiftUI

struct PickerSelector:View {
    let title:String
    let instruction:String
    @Binding var state:Bool
    @Binding var data:String
    @Binding var text:String
    @State private var pickerData:String = ""
    @State private var pickerState:Bool = false
    var body: some View {
        ZStack {
            HStack(alignment: .top, spacing: 30) {
                Text(title + ":")
                    .foregroundColor(.orange)
                    .frame(width: 150,alignment: .leading)
                    .font(.system(size: 25))
                Button {
                    data = title
                    state = true
                } label: {
                    Text(text)
                        .frame(width: 220,height: 35,alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.05))
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
    }
}
struct PickerView: View {
    @Binding var text:String
    @Binding var myView:Bool
    var inputArray:[String]
    @State var selected = 0
    var body: some View {
        VStack(spacing:0){
            Picker(selection: $selected) {
                ForEach(inputArray.indices) { item in
                    Text(inputArray[item]).tag(item)
                }
            } label: {
                Text("choose")
            }
            .pickerStyle(.wheel)
            .background(.white)
            .clipped()
            Button {
                text = inputArray[selected]
                myView = false
            } label: {
                Text("Done")
            }
        }
        .frame(width: UIScreen.main.bounds.width - 100,height: 270)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 2)
        )
        .background(.white)
        
        
        
        
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        let inputArray = ["100","101","102"]
        PickerView(text: .constant("test"), myView: .constant(false),inputArray: inputArray)
    }
}
