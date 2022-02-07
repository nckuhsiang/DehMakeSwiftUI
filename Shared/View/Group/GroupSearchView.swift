//
//  SearchGroupView.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/28.
//

import SwiftUI
import Combine
import Alamofire
import CryptoKit
struct GroupSearchView: View {
    @EnvironmentObject var setting:SettingStore
    
    @State private var cancellable: AnyCancellable?
    @State private var text:String = ""
    @State var publicGroups:[PublicGroups.Name] = []
    var searchResults: [PublicGroups.Name] {
        //get
        if text.isEmpty {
            return publicGroups
        } else {
            return publicGroups.filter { ($0.name).contains(text) }
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(searchResults) { group in
                    GroupItem(name: group.name)
                }
            }
            .listStyle(.plain)
            .searchable(text: $text,placement: .navigationBarDrawer)
        }
        .onAppear {
            getPublicGroups()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Group Join".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}
extension GroupSearchView {
    func getPublicGroups() {
        let url = GroupGetListUrl
        let parameters = ["username":setting.account,
                          "coi_name":setting.coi]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: PublicGroups.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                publicGroups = values.value?.result ?? []
            })
    }
}
struct GroupItem:View {
    var name:String
    @EnvironmentObject var setting:SettingStore
    @State private var cancellable: AnyCancellable?
    @State private var alertState:Bool = false
    @State private var response:String = ""
    @State private var resState:Bool = false
    var body: some View {
        Button {
            alertState = true
        } label: {
            Text(name)
        }
        .alert("Would you want to join \(name)", isPresented: $alertState) {
            Button {
                join(name:name)
            } label: {
                Text("Yes")
            }
            Button {
            } label: {
                Text("No")
            }
        }
        .alert(response, isPresented: $resState) {
            Text("OK")
        }
    }
    
}
extension GroupItem {
    func join(name:String){
        let url = GroupMemberJoinUrl
        let temp = """
        {
            "sender_name": "\(setting.account)",
            "group_name": "\(name)"
        }
"""
        let parameters = ["join_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                response = values.value?.message ?? "error"
                resState = true
            })
    }
}
struct SearchGroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSearchView().environmentObject(SettingStore())
    }
}
