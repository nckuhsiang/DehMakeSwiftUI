//
//  GroupInfoView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/5.
//

import SwiftUI
import Combine
import Alamofire

struct GroupInfoView:View{
    let group:Group
    @State var buttonText:String
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var setting:SettingStore
    @State private var cancellable: AnyCancellable?
    @State private var name:String = ""
    @State private var description:String = ""
    
    @State private var alertState:Bool = false
    @State private var alertText:String = ""
    @State private var disableState:Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack {
                Text("Group Name:")
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .disabled(disableState)
            }
            Text("information")
            TextEditor(text: $description)
                .frame(height:400)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
                .disabled(disableState)
            if setting.id == group.leaderId || buttonText == "Create"{
                Button {
                    butttonClick()
                } label: {
                    Text(buttonText)
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(.orange)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .alert(alertText, isPresented: $alertState) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("OK".localized)
            }
        }
        .onAppear {
            name = group.name
            description = group.info
            if buttonText == "Create"{
                disableState = false
            }
        }
        .padding()
    }
}
extension GroupInfoView {
    func butttonClick(){
        switch buttonText {
        case "Create":
            createGroup()
        case "Edit":
            buttonText = "Save"
            disableState = false
        default:
            updateGroup()
        }
    }
    func updateGroup() {
        let url = GroupUpdateUrl
        let temp = """
        {
        "group_name": "\(name)",
        "group_info": "\(description)",
        "group_id": "\(group.id)"
        }
        """
        let parameters = ["group_update_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: { (values) in
                alertState = true
                alertText = values.value?.message.localized ?? ""
            })
    }
    func createGroup() {
        let url = GroupCreatUrl
        let temp = """
        {
            "group_name":"\(name)",
            "group_leader_name":"\(setting.account)",
            "group_info":"\(description)",
            "language": "\(language)",
            "verification": "0",
            "open":"1",
            "coi_name":"\(setting.coi)"
        }
"""
        let parameters:[String:String] = ["group_information":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                alertText = values.value?.message.localized ?? ""
                self.alertState = true
            })
    }
}

struct GroupInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoView(group: Group(id: 1, name: "Mmnetlab", leaderId: 1, info: "test"), buttonText: "Create").environmentObject(SettingStore())
    }
}
