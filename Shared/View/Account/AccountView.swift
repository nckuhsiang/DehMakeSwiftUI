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
    let website = ["deh":DEHHomePageUrl,
                   "sdc":SDCHomePageUrl,
                   "extn":ExpTainanHomePageUrl]
    @EnvironmentObject var uvm:UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var account = ""
    @State private var password = ""
    var body: some View {
        VStack(alignment: .center, spacing: 5){
            Image("\(uvm.coi)_icon")
            HStack {
                Text(uvm.coi)
                Link(destination: URL(string:website[uvm.coi] ?? "http://deh.csie.ncku.edu.tw/")!, label: {
                    Text("more...".localized)
                })
            }
            .padding(.bottom,50)
            VStack {
                TextField("account".localized, text: $uvm.account)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300, height: 35)
                SecureField("password".localized,text: $uvm.password)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300, height: 35)
                
            }
            .padding(.bottom,20)
            
            VStack {
                    Button {
                        print("login enter")
                        uvm.login()
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
        .alert(uvm.alertText, isPresented: $uvm.alertState, actions: {
            Button {
                if uvm.alertText == "login success".localized {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("OK".localized)
            }
        })
        
    }
}
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(UserViewModel())
    }
}
