//
//  GroupInfoView.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/5.
//

import SwiftUI
import Combine
import Alamofire

struct GroupInfoView:View{
    let group:Group
    @State var buttonText:String
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var cancellable: AnyCancellable?
    @State private var name:String = ""
    @State private var description:String = ""
    @State private var disableState:Bool = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    Text("Group Name:")
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .disabled(disableState)
                }
                Text("information")
                TextEditor(text: $description)
                    .frame(height:400)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.05))
                    .onTapGesture {
                        UIApplication.dismissKeyboard()
                    }
                    .disabled(disableState)
                if uvm.id == group.leaderId || buttonText == "Create"{
                    Button {
                        butttonClick()
                    } label: {
                        Text(buttonText)
                            .padding(.vertical,10)
                            .padding(.horizontal)
                            .background(.orange)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
        }
        .alert(gvm.updateResponseText, isPresented: $gvm.showUpdateResponse) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("OK".localized)
            }
        }
        .onAppear {
            name = group.name
            description = group.info
            if buttonText == "Create"{
                disableState = false
            }
        }
        .padding()
    }
}
extension GroupInfoView {
    func butttonClick(){
        switch buttonText {
        case "Create":
            gvm.createGroup(account: uvm.account, name: name, description: description, language: language, coi: uvm.coi)
        case "Edit":
            buttonText = "Save"
            disableState = false
        default:
            gvm.updateGroup(name: name, id: group.id, description: description)
        }
    }
    
    
}

struct GroupInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GroupInfoView(group: Group(id: 1, name: "Mmnetlab", leaderId: 1, info: "test"), buttonText: "Create").environmentObject(UserViewModel())
    }
}
