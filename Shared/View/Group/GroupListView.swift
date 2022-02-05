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
    @State private var groups:[Group] = []
    var body: some View {
        VStack(spacing: 0){
            List {
                ForEach(self.groups) { group in
                    NavigationLink(destination: GroupDetailView()) {
                        listItem(picture: group.leaderId == setting.id ? "leaderrr":"leaderlisticon", title: group.name, decription:  group.leaderId == setting.id ? "leader":"member")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            NavigationLink(destination: GroupDetailView()){
                Text("Create Group")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .font(.system(size: 40))
            }
            .padding(.top)
            .background(.orange)
            
        }
        
        .onAppear {
            getGroupList()
        }
    }
    
}
extension GroupListView {
    func getGroupList(){
        let languageList = ["zh": "中文",
                            "jp": "日文",
                            "en": "英文",
        ]
        let language = languageList[Locale.current.languageCode ?? ""] ?? "英文"
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
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView().environmentObject(SettingStore())
    }
}
