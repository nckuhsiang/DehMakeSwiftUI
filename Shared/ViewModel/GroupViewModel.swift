//
//  GroupViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
class GroupViewModel:ObservableObject {
    private var cancellable: AnyCancellable?
    private var cancellable2: AnyCancellable?
    
    @Published var groups:[Group] = []
    @Published var groups_name:[String] = []
    @Published var infos:[GroupNotification.Info] = []
    @Published var members:[GroupMember.Member] = []
    @Published var publicGroups:[PublicGroups.Name] = []
    
    //For SearchView
    @Published var JoinResponseText:String = ""
    @Published var showJoinResponse:Bool = false
    @Published var showWantJoin:Bool = false
    
    //For InfoView
    @Published var updateResponseText:String = ""
    @Published var showUpdateResponse:Bool = false
    
    //For ListView
    @Published var displayMessageView:Bool = false
    
    //For MessageView
    @Published var messageResponseText:String = ""
    @Published var showMessageResponse:Bool = false
    
    //For MemberListView
    @Published var inviteResponseText:String = ""
    @Published var showInviteResponse:Bool = false
    
    
    func getGroupList(id:Int,coi:String,language:String){
        let url = GroupGetUserGroupListUrl
        let parameters = [
            "user_id": "\(id)",
            "coi_name": coi,
            "language": language,
        ]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupLists.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                self.groups = values.value?.results ?? []
            })
    }
    func getGroupNameList(id:Int,coi:String,language:String){
        let url = GroupGetUserGroupListUrl
        let parameters = [
            "user_id": "\(id)",
            "coi_name": coi,
            "language": language,
        ]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupLists.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                self.groups_name = ["Me".localized]
                let tmp = values.value?.results ?? []
                for group in tmp {
                    self.groups_name.append(group.name)
                }
            })
    }
    func joinGroup(account:String,name:String){
        let url = GroupMemberJoinUrl
        let temp = """
        {
            "sender_name": "\(account)",
            "group_name": "\(name)"
        }
"""
        let parameters = ["join_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                self.JoinResponseText = values.value?.message ?? "error"
                self.showWantJoin = true
            })
    }
    func createGroup(account:String,name:String,description:String,language:String,coi:String) {
        let url = GroupCreatUrl
        let temp = """
        {
            "group_name":"\(name)",
            "group_leader_name":"\(account)",
            "group_info":"\(description)",
            "language": "\(language)",
            "verification": "0",
            "open":"1",
            "coi_name":"\(coi)"
        }
"""
        let parameters:[String:String] = ["group_information":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                
                self.updateResponseText = values.value?.message.localized ?? ""
                self.showUpdateResponse = true
            })
    }
    func updateGroup(name:String,id:Int,description:String) {
        let url = GroupUpdateUrl
        let temp = [
        "group_name": "\(name)",
        "group_info": "\(description)",
        "group_id": "\(id)"
        ]
        let parameters = ["group_update_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: { (values) in
                self.showUpdateResponse = true
                self.updateResponseText = values.value?.message.localized ?? ""
            })
    }
    func getGroupMessages(account:String) {
        let url = GroupGetNotifiUrl
        let temp = """
        {
            "username":"\(account)"
        }
        """
        let parameters = ["notification":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupNotification.self, queue: .main)
        cancellable2 = publisher
            .sink(receiveValue: { (values) in
                let message = values.value?.message ?? ""
                if message == "have notification" {
                    self.displayMessageView = true
                    self.infos = values.value?.result ?? []
                }
            })
    }
    func responseMessage(sender:String,id:Int, action:String,account:String,coi:String) {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(sender)",
            "receiver_name":"\(account)",
            "group_id":"\(id)",
            "message_type":"\(action)",
            "coi_name":"\(coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        cancellable = publisher.sink(receiveValue: { values in
            self.messageResponseText = values.value?.message ?? "error"
            self.showMessageResponse = true
        })
    }
    func getGroupMember(group_id:Int,coi:String){
        let url = GroupGetMemberUrl
        let parameters =
        ["group_id":"\(group_id)",
         "coi_name":coi]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: GroupMember.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                self.members = values.value?.result ?? []
            })
    }
    func inviteMember(account:String,name:String,group_id:Int,coi:String) {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(account)",
            "receiver_name":"\(name)",
            "group_id":"\(group_id)",
            "message_type":"Invite",
            "coi_name":"\(coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: Message.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                self.inviteResponseText = values.value?.message ?? "Error"
                self.showInviteResponse = true
            })
    }
    func getPublicGroups(account:String,coi:String) {
        let url = GroupGetListUrl
        let parameters = ["username":account,
                          "coi_name":coi]
        let publisher = AF.request(url, method: .post, parameters: parameters)
            .publishDecodable(type: PublicGroups.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: {(values) in
                self.publicGroups = values.value?.result ?? []
            })
    }
}
