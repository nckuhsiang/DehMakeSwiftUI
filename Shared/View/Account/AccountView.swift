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
    @State var account:String = ""
    @State var password:String = ""
    @State private var cancellable: AnyCancellable?
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            Image("\(setting.coi)_icon")
            HStack {
                Text(setting.coi)
                Link(destination: URL(string:website[setting.coi] ?? "http://deh.csie.ncku.edu.tw/")!, label: {
                    Text("more...")
                })
            }
            .padding(.bottom,50)
            VStack {
                TextField("account", text: $account)
                    .frame(width: 300, height: 35)
                    .cornerRadius(5)
                    .border(.gray,width: 0.5)
                
                    
                SecureField("password",text: $password)
                    .frame(width: 300, height: 35)
                    .cornerRadius(5)
                    .border(.gray,width: 0.5)
                    
            }
            .padding(.bottom,20)

            VStack {
                Button {
                    login()
                } label: {
                    Text("login")
                        .frame(width: 300, height: 35)
                        .foregroundColor(.white)
                        .background(.selection)
                        .cornerRadius(10)
                }
                Link(destination: URL(string:"http://deh.csie.ncku.edu.tw/regist/")!, label: {
                    Text("register")
                        .frame(width: 300, height: 35)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                })
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Account Info")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: COIView()){
                    Text("change COI")
                        .foregroundColor(.white)
                }
            }
        }
        
    }
}
extension AccountView {
    func login() {
        let url = UserLoginUrl
        let parameter = [
            "username":account,
            "password":password,
            "coi_name":setting.coi
        ]
//        let loginHeaders = ["Authorization": "Token " + token]
        let publisher = AF.request(url, method: .post, parameters: parameter)
            .publishDecodable(type: loginModel.self, queue: .main)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                if let user = values.value {
                    print(user)
                    setting.account = account
                    setting.password = password.md5()
                    setting.id = user.id
                    setting.name = user.name
                }
            })
        
    }
}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(SettingStore())
    }
}
