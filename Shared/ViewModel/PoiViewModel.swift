//
//  PoiViewModel.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/23.
//

import Foundation


class PoiViewModel: ObservableObject {
    @Published var name:String = ""
    @Published var format:String = "All"
    @Published var keyword:String = ""
    @Published var group:String = "Me"
    @Published var description:String = ""
 
    
    
    @Published var showLocationAlert:Bool = false
    
}
