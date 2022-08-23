//
//  GroupMessageView.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/28.
//

import SwiftUI
import Alamofire
import Combine
//傳遞訊息與動態刪除訊息清單的地方寫的有點醜
struct GroupMessageView: View {
    @State var infos:[GroupNotification.Info]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    var body: some View {
        VStack {
            List {
                ForEach(infos) { info in
                    MessageItem(info: info,infos: $infos)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Message List".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

struct MessageItem:View{
    var info:GroupNotification.Info
    @Binding var infos:[GroupNotification.Info]
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var cancellable: AnyCancellable?
    @State private var sheetState:Bool = false
    @State private var alertText:String = ""
    @State private var alertState:Bool = false
    var body: some View{
        Button {
            sheetState = true
        } label: {
            HStack {
                Image(systemName: "envelope")
                Text("\(info.sender) " + "invite you to join".localized + " \(info.name)")
                    .foregroundColor(.black)
            }
        }
        .confirmationDialog("Would you want to join" + " \(info.name)?", isPresented: $sheetState, titleVisibility: .visible) {
                Button {
                    gvm.responseMessage(sender: info.sender, id: info.id, action: "Agree", account: uvm.account, coi: uvm.coi)
                    if let index = infos.firstIndex(of:info) {
                        infos.remove(at: index)
                    }
                } label: {
                    Text("Yes")
                        .foregroundColor(.blue)
                }
            Button(role: .destructive){
                gvm.responseMessage(sender: info.sender, id: info.id, action: "Reject", account: uvm.account, coi: uvm.coi)
                    if let index = infos.firstIndex(of:info) {
                        infos.remove(at: index)
                    }
                } label: {
                    Text("No")
                        .foregroundColor(.red)
                }
        }
        .alert(alertText, isPresented: $alertState) {
            Text("OK")
        }
        .padding()
    }
}
extension MessageItem{
    
}
    
//struct GroupMessageView_Previews: PreviewProvider {
//    @State static var infos:[GroupNotification.Info] = []
//    static var previews: some View {
//        GroupMessageView(info:GroupNotification.Info(name: "test", sender: "ray", type: "test", id: 1),infos:$infos).environmentObject(SettingStore())
//    }
//}
