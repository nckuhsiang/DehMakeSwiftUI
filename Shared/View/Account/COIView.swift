//
//  COIView.swift
//  DehMake-SwiftUI
//
//  Created by 陳家庠 on 2022/1/30.
//

import SwiftUI

struct COIView: View {
    var body: some View {
        List {
            Text("choose COI".localized)
            COIItem(coi: "deh", title: "DEH 文史脈流")
            COIItem(coi: "sdc", title: "SDC 校本課程")
            COIItem(coi: "extn", title: "EXTN 踏溯台南")
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("COI List".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .listStyle(GroupedListStyle())
    }
}
struct COIItem: View{
    let coi:String
    let title:String
    @EnvironmentObject var uvm:UserViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button {
            uvm.coi = coi
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 20){
                Image("\(coi)_icon")
                Text(title)
                    .font(.title)
                    .foregroundColor(.black)
            }
        }
        
    }
}

struct COIView_Previews: PreviewProvider {
    static var previews: some View {
        COIView()
    }
}

