//
//  SaveHTML+CoreDataProperties.swift
//  TestApp
//
//  Created by Мельник Максим on 23.02.2023.
//
//

import Foundation
import CoreData


extension SaveHTML {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveHTML> {
        return NSFetchRequest<SaveHTML>(entityName: "SaveHTML")
    }

    @NSManaged public var content: Data?
    @NSManaged public var url: String?

}

extension SaveHTML : Identifiable {

}
