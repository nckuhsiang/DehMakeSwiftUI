//
//  CoreDataManager.swift
//  DehMakeSwiftUI
//
//  Created by 陳家庠 on 2022/9/1.
//
import CoreData
import Foundation

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init(){
        container = NSPersistentContainer(name: "POI")
        container.loadPersistentStores(completionHandler: { (description,error) in
            if let error = error {
                print("Error loading Core data. \(error)")
            }
        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
        context = container.viewContext
    }
    
    func save(){
        do {
            try context.save()
        }
        catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
}
