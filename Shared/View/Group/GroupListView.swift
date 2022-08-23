//
//  GroupListView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/1/30.
//

import SwiftUI
import Combine
import Alamofire

struct GroupListView: View {
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    var body: some View {
        VStack(spacing: 0){
            List(gvm.groups){ group in
                    NavigationLink(destination: GroupDetailView(group: group)) {
                        listItem(picture: group.leaderId == uvm.id ? "leaderrr":"leaderlisticon", title: group.name, decription:  group.leaderId == uvm.id ? "leader":"member")
                    }
            }
            .listStyle(.plain)
            NavigationLink(destination: GroupInfoView(group: Group(id: -1, name: "", leaderId: -1, info: ""), buttonText:"Create")){
                Text("Create Group")
                    .frame(maxWidth: .infinity,maxHeight: 20)
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }
            .padding(.top)
            .background(.orange)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Group List".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if gvm.displayMessageView {
                        NavigationLink(destination: GroupMessageView(infos: gvm.infos)) {
                            Image(systemName: "message.circle.fill")
                        }
                    }
                    NavigationLink(destination: GroupSearchView()) {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
                .foregroundColor(.white)
                
            }
        }
        .onAppear {
            gvm.getGroupMessages(account: uvm.account)
            gvm.getGroupList(id: uvm.id, coi: uvm.coi, language: language)
        }
    }
    
}


struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView().environmentObject(UserViewModel())
    }
}
