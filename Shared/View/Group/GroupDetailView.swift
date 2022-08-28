//
//  GroupDetailView.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/28.
//

import SwiftUI
import Combine
import Alamofire

struct GroupDetailView: View {
    let group:Group
    var body: some View {
        TabView {
            GroupInfoView(group:group, action: Action.edit)
                .tabItem {
                    Image("file")
                    Text("Information".localized)
                }
            GroupMemberListView(group:group)
                .tabItem {
                    Image("groupmember")
                    Text("Member".localized)
                }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Group Info".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(id: 1, name: "Mmnetlab", leaderId: 1, info: "test")).environmentObject(UserViewModel())
    }
}
