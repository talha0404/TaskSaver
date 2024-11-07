//
//  Task+CoreDataProperties.swift
//  Homework
//
//  Created by talha.sahin on 20.06.2024.
//
//

import Foundation
import CoreData


extension Task {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var details: String?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
