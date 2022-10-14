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
    @Published var folderPath = ""
//    @Published var loginState:Bool = false
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
//                    self.loginState = true
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
    func createFolder() {
        print("DEH Folder Creating")
        let fileManager1 = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPaths = (documentsDirectory as! NSString).appendingPathComponent("DEH-Image")
        if fileManager1.fileExists(atPath: dataPaths){
            print("Folder already exist!")
            folderPath = dataPaths
            print("Following is DEH photo path : ")
            print(folderPath)  ///var/mobile/Containers/Data/Application/5D894EEA-04BD-4AB9-A2F8-12D32711AFD4/Documents/DEH-Image
        }
        else{
            do {
                try FileManager.default.createDirectory(atPath: dataPaths, withIntermediateDirectories: false, attributes: nil)
                folderPath = dataPaths
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
    }
}
