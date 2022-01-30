//
//  POIModel.swift
//  DehMake-SwiftUI
//
//  Created by 陳家庠 on 2022/1/30.
//

import Foundation

class POI:Identifiable {
    let name:String
    let longitude:String
    let latitude:String
    let format:String
    let keyword:String
    let description:String
    let group:String
    let type:String
    init(_ name:String, _ longitude:String, _ latitude:String, _ format:String, _ keyword:String, _ description:String, _ group:String, _ type:String) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.format = format
        self.keyword = keyword
        self.description = description
        self.group = group
        self.type = type
    }
}
