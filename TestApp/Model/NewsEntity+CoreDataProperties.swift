//
//  NewsEntity+CoreDataProperties.swift
//  TestApp
//
//  Created by Мельник Максим on 23.02.2023.
//
//

import Foundation
import CoreData


extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var url: String?
    @NSManaged public var title: String?

}

extension NewsEntity : Identifiable {

}
extension NewsEntity{
    func toNews() -> News{
        return News(url: self.url!, title: self.title!, id: Int(self.id))
    }
}
