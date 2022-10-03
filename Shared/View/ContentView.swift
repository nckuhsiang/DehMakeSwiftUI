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
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Poi.id, ascending: true)],
        animation: .default) var pois: FetchedResults<Poi>
    @State private var showLogOutAlert:Bool = false
    @State private var showAccountView:Bool = false
    @State private var selection:UUID?
    @State private var type:mediaType?
    @State private var showActionSheet = false
    @State var showUploadSucess = false
    @State var token:String = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pois) { poi in
                        Button {
                            if poi.media_type == "image" { type = .image }
                            else if poi.media_type == "audio" {type = .audio }
                            else { type = .video }
                            showActionSheet = true
                            grantToken()
                        } label: {
                            NavigationLink(tag: poi.id!, selection: $selection, destination: {
                                PoiView(type: type ?? .image ,poi: poi)
                            }, label: {
                                listItem(picture: poi.media_type!, title: poi.title!, decription: poi.group!)
                                .confirmationDialog("What would you want to do".localized, isPresented: $showActionSheet, titleVisibility: .visible) {
                                    Button {
                                        selection = poi.id
                                    } label: {
                                        Text("edit".localized)
                                    }
                                    Button {
                                        uploadPoi(poi:poi)
                                    } label: {
                                        Text("upload".localized)
                                    }
                                }
                                
                            })
                        }
                    }
                    .onDelete(perform: deletePoi)
                }
                .alert("upload success", isPresented: $showUploadSucess, actions: {
                    Text("OK".localized)
                })
                
                .padding(.top)
                .listStyle(.plain)
                HStack {
                    Spacer()
                    NavigationLink(destination: PoiView(type: .image), label: {
                        Image("picture")
                    })
                    Spacer()
                    NavigationLink(destination: PoiView(type: .audio), label: {
                        Image("speaker")
                    })
                    Spacer()
                    NavigationLink(destination: PoiView(type: .video), label: {
                        Image("video-player")
                    })
                    Spacer()
                }
                
                .padding(.top)
                .background(.orange)
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
                        NavigationLink(destination: AccountView(),isActive: $showAccountView){
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    if uvm.loginState {
                                        showLogOutAlert = true
                                    }
                                    else {
                                        showAccountView = true
                                    }
                                }
                                .alert("Would you want to logout?", isPresented: $showLogOutAlert) {
                                    Button {
                                        uvm.logout()
                                        showAccountView = true
                                    } label: {
                                        Text("Yes")
                                    }
                                    Button {
                                        showLogOutAlert = false
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
//        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            gvm.getGroupNameList(id: uvm.id, coi: uvm.coi, language: language)
            uvm.createFolder()
        }
    }
}
extension ContentView {
    func deletePoi(offsets: IndexSet) {
        withAnimation {
            offsets.map { pois[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserViewModel())
    }
}
