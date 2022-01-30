//
//  ContentView.swift
//  Shared
//
//  Created by 陳家庠 on 2022/1/27.
//

import SwiftUI

struct ContentView: View {
    init() {
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = UIColor.black
        UINavigationBar.appearance().standardAppearance = barAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        UITableView.appearance().backgroundColor = .white
    }
    @State private var selection:Int? = nil
    @State private var picturePOI:Bool = false
    @State private var audioPOI:Bool = false
    @State private var videoPOI:Bool = false
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
                .listStyle(GroupedListStyle())
                HStack {
                    Spacer()
                    NavigationLink(destination: POIView(type: "picture"), label: {
                        Image("picture")
                    })
                    Spacer()
                    NavigationLink(destination: POIView(type: "speaker"), label: {
                        Image("speaker")
                    })
                    Spacer()
                    NavigationLink(destination: POIView(type: "video-player"), label: {
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
                    Text("POI List")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AccountView()){
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}
struct POIItem:View {
    var type:String
    var picture:String
    var title:String
    var decription:String
    var body: some View {
        NavigationLink(destination: POIView(type: type), label: {
            HStack(spacing: 20){
                Image(picture)
                VStack(alignment: .leading, spacing: 5){
                    Text(title)
                        .font(.title2)
                    Text(decription)
                        .font(.body)
                }
                .foregroundColor(.black)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SettingStore())
    }
}
