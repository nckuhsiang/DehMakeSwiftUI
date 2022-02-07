//
//  GroupMemberListView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/5.
//

import SwiftUI
import Combine
import Alamofire
struct GroupMemberListView:View {
    let group:Group
    @EnvironmentObject var setting:SettingStore
    @State var members:[GroupMember.Member] = []
    @State private var cancellable: AnyCancellable?
    @State private var name:String = ""
    @State private var alertState:Bool = false
    @State private var alertText:String = ""
    var body: some View {
        VStack {
            HStack {
                Text("invite:")
                TextField("User name", text: $name)
                    .textFieldStyle(.roundedBorder)
                Button {
                    invite()
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.orange)
                }
            }
            .padding(.bottom)
            Text("Group Member")
                .font(.system(size: 20, weight: .bold, design: .default))
            List {
                ForEach(members){ member in
                    HStack {
                        Image(member.role == "leader" ? "leaderrr":"leaderlisticon")
                        Text(member.name)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .alert(alertText, isPresented: $alertState) {
            Text("OK")
        }
        .padding()
        .onAppear {
            getGroupMember()
        }
    }
}
extension GroupMemberListView {
    func getGroupMember(){
        let url = GroupGetMemberUrl
        let parameters =
        ["group_id":"\(group.id)",
         "coi_name":setting.coi]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupMember.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                members = values.value?.result ?? []
            })
    }
    func invite() {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(setting.account)",
            "receiver_name":"\(name)",
            "group_id":"\(group.id)",
            "message_type":"Invite",
            "coi_name":"\(setting.coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                alertText = values.value?.message ?? "Error"
                alertState = true
            })
    }
}

struct GroupMemberListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMemberListView(group: Group(id: 1, name: "Mmnetlab", leaderId: 1, info: "test")).environmentObject(SettingStore())
    }
}
