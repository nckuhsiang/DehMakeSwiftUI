//
//  AccountView.swift
//  DehMake-SwiftUI
//
//  Created by 陳家庠 on 2022/1/30.
//

import SwiftUI
import Alamofire
import Combine

struct AccountView: View {
    let website = ["deh":"http://deh.csie.ncku.edu.tw/",
                   "sdc":"http://deh.csie.ncku.edu.tw/sdc",
                   "extn":"http://exptainan.liberal.ncku.edu.tw/"]
    @EnvironmentObject var setting:SettingStore
    @Environment(\.presentationMode) var presentationMode
    @State private var account:String = ""
    @State private var password:String = ""
    @State private var loginState:Bool = false
    @State private var alertState:Bool = false
    @State private var alertText:String = ""
    @State private var cancellable: AnyCancellable?
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            Image("\(setting.coi)_icon")
            HStack {
                Text(setting.coi)
                Link(destination: URL(string:website[setting.coi] ?? "http://deh.csie.ncku.edu.tw/")!, label: {
                    Text("more...".localized)
                })
            }
            .padding(.bottom,50)
            VStack {
                TextField("account".localized, text: $account)
                    .frame(width: 300, height: 35)
                    .cornerRadius(5)
                    .border(.gray,width: 0.5)
                
                
                SecureField("password".localized,text: $password)
                    .frame(width: 300, height: 35)
                    .cornerRadius(5)
                    .border(.gray,width: 0.5)
                
            }
            .padding(.bottom,20)
            
            VStack {
                    Button {
                        login()
                    } label: {
                        Text("login".localized)
                            .frame(width: 300, height: 35)
                            .foregroundColor(.white)
                            .background(.selection)
                            .cornerRadius(10)
                    }
                
                Link(destination: URL(string:"http://deh.csie.ncku.edu.tw/regist/")!, label: {
                    Text("register".localized)
                        .frame(width: 300, height: 35)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                })
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Account Info".localized)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: COIView()){
                    Text("change COI".localized)
                        .foregroundColor(.white)
                }
            }
        }
        .alert(alertText, isPresented: $alertState, actions: {
            Button {
                if alertText == "login success".localized {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("OK".localized)
            }
        })
        .onAppear {
            if setting.id != -1 {
                loginState = true
                account = setting.account
                password = "fakePassword"
            }
        }
        
    }
}
extension AccountView {
    func login() {
        let url = UserLoginUrl
        let parameter = [
            "username":account,
            "password":password.md5(),
            "coi_name":setting.coi
        ]
        let publisher = AF.request(url, method: .post, parameters: parameter)
            .publishDecodable(type: loginModel.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                
                if let _ = values.value?.message {
                    alertText = "login fail".localized
                    print("User" + "\(values.value?.message ?? "Not Found")")
                }
                else {
                    setting.account = account
                    setting.password = password.md5()
                    setting.id = values.value?.id ?? 0
                    setting.name = values.value?.name ?? ""
                    setting.role = values.value?.role ?? ""
                    loginState = true
                    alertText = "login success".localized
                    print("login success, user info:",setting.id,setting.name)
                }
                alertState = true
            })
    }
}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(SettingStore())
    }
}
