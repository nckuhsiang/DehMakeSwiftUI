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
                grantToken()
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
                uploadPoi()
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
extension PoiItem {
    func save() {
        do {
            try viewContext.save()
        } catch {
            // show error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func uploadPoi() {
        grantToken()
        var parameters:[String:Any] = ["year":poi.year,"group_name":(poi.group! == "Me" ? "" : poi.group!),"scope":poi.scope!,"keyword":poi.keyword!,"identifier":poi.identifier!,"longitude":poi.longitude!,"POI_title":poi.title!,"language":poi.language!,"open":poi.open,"type":poi.type!,"POI_description":poi.summary!,"source":poi.source!,"height":poi.height,"rights":poi.rights!,"period":poi.period!,"format":poi.format!,"subject":poi.subject!,"latitude":poi.latitude!,"POI_address":poi.address!,"COI_name":poi.coi!]
        var media_set:[[String:Any]] = []
        let header:HTTPHeader = HTTPHeader(name: "Authorization", value: "Token " + token)
        let headers:HTTPHeaders = HTTPHeaders([header])

        AF.upload(multipartFormData: { multipartFormData in
            if let arr = poi.poi_to_media?.allObjects {
                let medias = arr as! [Media]
                for media in medias {
                    media_set.append([
                        "media_path":media.path!,
                        "media_format":media.format,
                        "media_type":media.type!
                    ])
                    var mimeType = ""
                    if media.type! == "image" {mimeType = "image/jpeg"}
                    else if media.type! == "video" {mimeType = "video/MOV"}
                    else {mimeType = "audio/aac"}
                    multipartFormData.append(URL(fileURLWithPath: folderPath+media.path!), withName: "data", fileName: media.path!, mimeType: mimeType)
                    viewContext.delete(media)
                    save()
                }
                print(media_set)
                parameters["media_set"] = media_set
                if let JsonData = try? JSONSerialization.data(
                    withJSONObject: parameters,
                    options: [.prettyPrinted]) {
                    let JsonText = String(data: JsonData, encoding: .utf8)
      
                    multipartFormData.append(JsonText?.data(using: .utf8) ?? Data(), withName: "content")
                    
                }
                viewContext.delete(poi)
                save()
            }
        }, to: UploadPOIUrl,headers: headers).responseDecodable(of: Response.self) { response in
            print(response.value?.message ?? "")
            if response.value?.message == "file uploaded!" {
                print("test")
                showUploadSucess = true
            }
        }
        
        
    }
    func grantToken(){
        let SuperName = "test03"
        let SuperPassword = "0a291f120e0dc2e51ad32a9303d50cac"
        let Superparameters = ["username": SuperName, "password": SuperPassword]
        AF.request("http://deh.csie.ncku.edu.tw:8080/api/v1/grant", method: .post, parameters: Superparameters)
            .responseDecodable(of: Response.self){ response in
                if response.value?.message == "aithorization granted" {
                    token = (response.value?.token)!
                }
        }
    }
}
struct listItem_Previews: PreviewProvider {
    static var previews: some View {
        listItem(picture: "leaderrr", title: "test", decription: "test")
    }
}
