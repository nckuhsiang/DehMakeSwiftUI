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
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Poi.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Poi>
    
    @State private var selection:Int? = nil
    @State private var picturePOI:Bool = false
    @State private var audioPOI:Bool = false
    @State private var videoPOI:Bool = false
    @State private var alertState:Bool = false
    @State private var nextView:Bool = false
    @State private var showActionSheet = false
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selection) {
                    ForEach(items) { item in
                        Button(action: {
                            showActionSheet = true
                        }, label: {
                            listItem(picture: "picture", title: item.title ?? "", decription: item.summary ?? "")

                                .confirmationDialog("What would you want to do?".localized , isPresented: $showActionSheet, titleVisibility: .visible) {
                                    Button {
                                       
                                    } label: {
                                        Text("revise".localized)
                                            .foregroundColor(.blue)
                                    }
                                    Button {
                                        
                                    } label: {
                                        Text("upload".localized)
                                            .foregroundColor(.blue)
                                    }
                                }
                        })
                    }
                    .onDelete(perform: deletePoi)
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
}


extension ContentView {
    func deletePoi(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func uploadPoi(offsets: IndexSet) {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserViewModel())
    }
}
