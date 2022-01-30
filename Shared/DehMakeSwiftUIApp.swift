//
//  DehMakeSwiftUIApp.swift
//  Shared
//
//  Created by 陳家庠 on 2022/1/30.
//

import SwiftUI

@main
struct DehMakeSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SettingStore())
        }
    }
}
