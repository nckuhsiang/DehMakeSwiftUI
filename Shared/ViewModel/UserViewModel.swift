//
//  UserViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation
import Alamofire
import Combine

class UserViewModel:ObservableObject {
//    @Published var user:UserModel = UserDefaults.standard.object(forKey: "user") as? UserModel ?? UserModel() {
//        didSet {
//            UserDefaults.standard.set(user,forKey: "user")
//        }
//    }
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
    
    @Published var loginState:Bool = false
    @Published var alertState:Bool = false
    @Published var alertText:String = ""
    private var cancellable: AnyCancellable?
    
    func login() {
        let url = UserLoginUrl
        let parameter = [
            "username":self.account,
            "password":self.password.md5(),
            "coi_name":coi
        ]
        let publisher = AF.request(url, method: .post, parameters: parameter)
            .publishDecodable(type: UserModel.self, queue: .main)
        cancellable = publisher
            .sink(receiveValue: { values in
                if let _ = values.value?.message {
                    self.alertText = "login fail".localized
                    print("User" + "\(values.value?.message ?? "Not Found")")
                }
                else {
                    self.id = values.value?.id ?? 0
                    self.name = values.value?.account ?? ""
                    self.role = values.value?.role ?? ""
                    self.loginState = true
                    self.alertText = "login success".localized
                    print("login success, user info:",self.id,self.name)
                }
                self.alertState = true
            })
    }
    func logout() {
        self.account = ""
        self.password = ""
        self.id =  -1
        self.name = ""
        self.role = ""
    }
}
