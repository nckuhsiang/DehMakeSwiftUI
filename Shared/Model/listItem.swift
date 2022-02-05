//
//  listItem.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/5.
//

import SwiftUI

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

struct listItem_Previews: PreviewProvider {
    static var previews: some View {
        listItem(picture: "leaderrr", title: "test", decription: "test")
    }
}
