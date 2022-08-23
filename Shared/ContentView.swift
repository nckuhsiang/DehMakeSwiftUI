//
//  ContentView.swift
//  Shared
//
//  Created by 陳家庠 on 2022/1/27.
//

import SwiftUI
import CoreLocation
import Alamofire
import Combine

let languageList = ["zh": "中文",
                    "jp": "日文",
                    "en": "英文",
]
let language = languageList[Locale.current.languageCode ?? ""] ?? "英文"

enum mediaType {
    case image
    case audio
    case video
}

struct ContentView: View {
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .white
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor.black
        UINavigationBar.appearance().standardAppearance = barAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        
        UITabBar.appearance().backgroundColor = .orange
    }
    @EnvironmentObject var uvm:UserViewModel
    @EnvironmentObject var gvm:GroupViewModel
    @State private var selection:Int? = nil
    @State private var picturePOI:Bool = false
    @State private var audioPOI:Bool = false
    @State private var videoPOI:Bool = false
    @State private var alertState:Bool = false
    @State private var nextView:Bool = false
    @State private var cancellable: AnyCancellable?
//    let pois = [POI(name: "成功大學", belong: "屬於自己", type: "picture"),
//                POI(name: "資訊工程新館", belong: "屬於自己", type: "video"),
//                POI(name: "安平古堡", belong: "屬於自己", type: "audio"),
//    ]
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selection) {
//                    ForEach(pois) { poi in
//
//                    }
                }
                .listStyle(.plain)
                HStack {
                    Spacer()
                    NavigationLink(destination: POIView(type: mediaType.image), label: {
                        Image("picture")
                    })
                    Spacer()
                    NavigationLink(destination: POIView(type: mediaType.audio), label: {
                        Image("speaker")
                    })
                    Spacer()
                    NavigationLink(destination: POIView(type: mediaType.video), label: {
                        Image("video-player")
                    })
                    Spacer()
                }
                .padding(.top)
                .background(.orange)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: GroupListView()){
                        Image(systemName: "person.3.sequence")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Hi \(uvm.name)" )
                        .font(.title2)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AccountView(),isActive: $nextView){
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.white)
                            .onTapGesture {
                                if uvm.id != -1 {
                                    alertState = true
                                }
                                else {
                                    nextView = true
                                }
                            }
                            .alert("Would you want to logout?", isPresented: $alertState) {
                                Button {
                                    uvm.logout()
                                    nextView = true
                                } label: {
                                    Text("Yes")
                                }
                                Button {
                                    alertState = false
                                } label: {
                                    Text("No")
                                }
                            }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }        
    }
}
struct POIItem:View {
    var type:mediaType
    var picture:String
    var title:String
    var decription:String
    var body: some View {
        NavigationLink(destination: POIView(type: type), label: {
           listItem(picture: picture, title: title, decription: decription)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserViewModel())
    }
}
