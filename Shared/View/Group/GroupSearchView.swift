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
    @State var publicGroups:[PublicGroupList.PublicGroup] = []
    var body: some View {
        VStack {
            List {
                ForEach(publicGroups) { group in
                    Button {
                        
                    } label: {
                        Text(group.name)
                    }
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            getPublicGroups()
        }
    }
}
extension GroupSearchView {
    func getPublicGroups() {
        let url = GroupGetListUrl
        let parameters = ["username":setting.account,
                          "coi_name":setting.coi]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: PublicGroupList.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                self.publicGroups = values.value?.result ?? []
            })
    }
}

struct SearchGroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSearchView()
    }
}
