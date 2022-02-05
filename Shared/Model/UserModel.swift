//
//  UserModel.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/29.
//

import Foundation
import SwiftUI

class SettingStore:ObservableObject {
    @Published var account:String = UserDefaults.standard.string(forKey: "account") ?? "" {
        didSet {
            UserDefaults.standard.set(account, forKey: "account")
        }
    }
    @Published var password:String = UserDefaults.standard.string(forKey: "password") ?? "" {
        didSet {
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    @Published var name:String = UserDefaults.standard.string(forKey: "name") ?? "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    @Published var id:Int = UserDefaults.standard.integer(forKey: "id") {
        didSet {
            UserDefaults.standard.set(id, forKey: "id")
        }
    }
    @Published var coi:String = UserDefaults.standard.string(forKey: "coi") ?? "deh" {
        didSet {
            UserDefaults.standard.set(coi, forKey: "coi")
        }
    }
    @Published var role:String = UserDefaults.standard.string(forKey: "role") ?? "" {
        didSet {
            UserDefaults.standard.set(role, forKey: "role")
        }
    }
    
}
class loginModel: Decodable {
    let account:String!
    let password:String!
    let name:String!
    let id:Int!
    let nickname:String!
    let email:String!
    let role:String!
    let birthday:String!
    let message:String!
    init(account:String,password:String,name:String,id:Int,nickname:String,email:String,birthday:String,role:String,message:String) {
        self.account = account
        self.password = password
        self.name = name
        self.id = id
        self.nickname = nickname
        self.email = email
        self.birthday = birthday
        self.role = role
        self.message = message
    }
    enum CodingKeys:String, CodingKey {
        case account
        case password
        case name = "username"
        case id = "user_id"
        case nickname
        case email
        case role
        case birthday
        case message
    }
}
