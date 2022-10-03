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
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var text:String = ""
    
    var searchResults: [PublicGroups.Name] {
        if text.isEmpty {
            return gvm.publicGroups
        } else {
            return gvm.publicGroups.filter { ($0.name).contains(text) }
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
            gvm.getPublicGroups(account: uvm.account, coi: uvm.coi)
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
struct GroupItem:View {
    var name:String
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var alertState:Bool = false
    var body: some View {
        Button {
            alertState = true
        } label: {
            Text(name)
        }
        .alert("Would you want to join".localized + "\(name)", isPresented: $alertState) {
            Button {
                gvm.joinGroup(account: uvm.account, name: name)
            } label: {
                Text("Yes".localized)
            }
            Button {
            } label: {
                Text("No".localized)
            }
        }
        .alert(gvm.JoinResponseText, isPresented: $gvm.showJoinResponse) {
            Text("OK".localized)
        }
    }
    
}
struct SearchGroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSearchView().environmentObject(UserViewModel())
    }
}
