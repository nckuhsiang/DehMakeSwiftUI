//
//  UserModel.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/1/29.
//

import Foundation
import SwiftUI


struct UserModel: Decodable {
    var account:String? = ""
    var id:Int? = -1
    var nickname:String? = ""
    var email:String? = ""
    var role:String? = ""
    var birthday:String? = ""
    var message:String?

    enum CodingKeys:String, CodingKey {
        case account = "username"
        case id = "user_id"
        case nickname
        case email
        case role
        case birthday
        case message
    }
}

