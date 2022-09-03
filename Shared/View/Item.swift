//
//  listItem.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/5.
//

import SwiftUI
import Alamofire

struct listItem: View {
    var picture:String
    var title:String
    var decription:String
    var body: some View {
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
    }
}
struct PoiItem: View {
    @Environment(\.managedObjectContext) var viewContext
    var poi:FetchedResults<Poi>.Element
    @Binding var folderPath:String
    @State private var type:mediaType = .image
    @State private var token:String = ""
    @State private var pic = ""
    @State private var title = ""
    @State private var group = ""
    @State private var showActionSheet = false
    @State private var showReviseView = false
    @State private var showUploadSucess = false
    var body: some View {
        listItem(picture: pic, title: title, decription: group)
            .onTapGesture {
                if poi.media_type == "image" { type = .image }
                else if poi.media_type == "audio" {type = .audio }
                else { type = .video }
                showActionSheet.toggle()
//                grantToken()
            }
        .alert("upload success", isPresented: $showUploadSucess, actions: {
            Text("OK".localized)
        })
        .confirmationDialog("What would you want to do".localized, isPresented: $showActionSheet, titleVisibility: .visible) {
            Button {
                showReviseView = true
            } label: {
                Text("edit".localized)
            }
            Button {
//                uploadPoi()
            } label: {
                Text("upload".localized)
            }
        }
        .onAppear {
            pic = poi.media_type!
            title = poi.title!
            group = poi.group!
        }
    }
}

struct listItem_Previews: PreviewProvider {
    static var previews: some View {
        listItem(picture: "leaderrr", title: "test", decription: "test")
    }
}
