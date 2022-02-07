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
    @EnvironmentObject var setting:SettingStore
    @State private var cancellable: AnyCancellable?
    @State private var cancellable2: AnyCancellable?
    @State private var groups:[Group] = []
    @State private var infos:[GroupNotification.Info] = []
    @State private var alertState:Bool = false
    var body: some View {
        VStack(spacing: 0){
            List {
                ForEach(self.groups) { group in
                    NavigationLink(destination: GroupDetailView(group: group)) {
                        listItem(picture: group.leaderId == setting.id ? "leaderrr":"leaderlisticon", title: group.name, decription:  group.leaderId == setting.id ? "leader":"member")
                    }
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
                    if alertState {
                        NavigationLink(destination: GroupMessageView(infos: infos)) {
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
            getGroupList()
            getGroupMessages()
        }
    }
    
}
extension GroupListView {
    func getGroupList(){
        let url = GroupGetUserGroupListUrl
        let parameters = [
            "user_id": "\(setting.id)",
            "coi_name": setting.coi,
            "language": language,
        ]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupLists.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                self.groups = values.value?.results ?? []
            })
    }
    func getGroupMessages() {
        let url = GroupGetNotifiUrl
        let temp = """
        {
            "username":"\(setting.account)"
        }
        """
        let parameters = ["notification":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupNotification.self, queue: .main)
        cancellable2 = publisher
            .sink(receiveValue: { (values) in
                let message = values.value?.message ?? ""
                if message == "have notification" {
                    alertState = true
                    infos = values.value?.result ?? []
                }
            })
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView().environmentObject(SettingStore())
    }
}
