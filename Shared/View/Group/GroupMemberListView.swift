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
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var name:String = ""
    var body: some View {
        VStack {
            HStack {
                Text("invite:".localized)
                TextField("User name".localized, text: $name)
                    .textFieldStyle(.roundedBorder)
                Button {
                    gvm.inviteMember(account: uvm.account, name: name, group_id: group.id, coi: uvm.coi)
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.orange)
                }
            }
            .padding(.bottom)
            Text("Group Member".localized)
                .font(.system(size: 20, weight: .bold, design: .default))
            List {
                ForEach(gvm.members){ member in
                    HStack {
                        Image(member.role == "leader" ? "leaderrr":"leaderlisticon")
                        Text(member.name)
                    }
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .alert(gvm.inviteResponseText, isPresented: $gvm.showInviteResponse) {
            Text("OK".localized)
        }
        .padding()
        .onAppear {
            gvm.getGroupMember(group_id: group.id, coi: uvm.coi)
        }
    }
}
extension GroupMemberListView {
    
}

struct GroupMemberListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMemberListView(group: Group(id: 1, name: "Mmnetlab", leaderId: 1, info: "test")).environmentObject(UserViewModel())
    }
}


