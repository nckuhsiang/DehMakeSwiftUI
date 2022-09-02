//
//  DehMakeSwiftUIApp.swift
//  Shared
//
//  Created by 陳家庠 on 2022/1/30.
//

import SwiftUI

@main
struct DehMakeSwiftUIApp: App {
//    let persistenceController = PersistenceController.shared
    let coreDataManager = CoreDataManager.instance
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserViewModel())
                .environmentObject(GroupViewModel())
                .environment(\.managedObjectContext, coreDataManager.context)
        }
        
    }
}
