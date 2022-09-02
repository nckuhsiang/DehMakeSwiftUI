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
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pois) { poi in
                        PoiItem(poi: poi, folderPath: $uvm.folderPath)
                    }
                    .onDelete(perform: deletePoi)
                }
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
