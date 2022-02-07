//
//  GroupMessageView.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/28.
//

import SwiftUI
import Alamofire
import Combine
struct GroupMessageView: View {
    @State var infos:[GroupNotification.Info]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var setting:SettingStore
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
    @EnvironmentObject var setting:SettingStore
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
                    responseMessage(sender: info.sender, id: info.id, action: "Agree")
                    if let index = infos.firstIndex(of:info) {
                        infos.remove(at: index)
                    }
                } label: {
                    Text("Yes")
                        .foregroundColor(.blue)
                }
            Button(role: .destructive){
                    responseMessage(sender: info.sender, id: info.id, action: "Reject")
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
    func responseMessage(sender:String,id:Int, action:String) {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(sender)",
            "receiver_name":"\(setting.account)",
            "group_id":"\(id)",
            "message_type":"\(action)",
            "coi_name":"\(setting.coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher.sink(receiveValue: { values in
            alertText = values.value?.message ?? "error"
            alertState = true
        })
    }
}
    
//struct GroupMessageView_Previews: PreviewProvider {
//    @State static var infos:[GroupNotification.Info] = []
//    static var previews: some View {
//        GroupMessageView(info:GroupNotification.Info(name: "test", sender: "ray", type: "test", id: 1),infos:$infos).environmentObject(SettingStore())
//    }
//}
