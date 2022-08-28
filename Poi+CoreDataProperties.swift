//
//  Poi+CoreDataProperties.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/8/28.
//
//

import Foundation
import CoreData


extension Poi {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poi> {
        return NSFetchRequest<Poi>(entityName: "Poi")
    }

    @NSManaged public var address: String?
    @NSManaged public var format: String?
    @NSManaged public var group: String?
    @NSManaged public var height: String?
    @NSManaged public var id: Int32
    @NSManaged public var identifier: String?
    @NSManaged public var keyword: String?
    @NSManaged public var language: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var media_set: String?
    @NSManaged public var media_type: String?
    @NSManaged public var open: Int32
    @NSManaged public var period: String?
    @NSManaged public var rights: String?
    @NSManaged public var scope: String?
    @NSManaged public var source: String?
    @NSManaged public var subject: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var year: Int32
    @NSManaged public var coi: String?

}

extension Poi : Identifiable {

}
