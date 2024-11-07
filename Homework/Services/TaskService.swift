//
//  TaskService.swift
//  Homework
//
//  Created by talha.sahin on 6.06.2024.
//

import Foundation
import CoreData

class TaskService: TaskServiceProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchTasks() -> [TaskDTO] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { TaskDTO(id: $0.id!, title: $0.title!, details: $0.details!, isCompleted: $0.isCompleted) }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func fetchTask(by id: UUID) -> TaskDTO? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let taskEntities = try context.fetch(fetchRequest)
            if let taskEntity = taskEntities.first {
                return TaskDTO(id: taskEntity.id!, title: taskEntity.title!, details: taskEntity.details!, isCompleted: taskEntity.isCompleted)
            }
        } catch {
            print("Failed to fetch task: \(error)")
        }

        return nil
    }

    func createTask(title: String, details: String) -> TaskDTO {
        let taskEntity = Task(context: context)
        taskEntity.id = UUID()
        taskEntity.title = title
        taskEntity.details = details
        taskEntity.isCompleted = false

        CoreDataStack.shared.saveContext()

        return TaskDTO(id: taskEntity.id!, title: taskEntity.title!, details: taskEntity.details!, isCompleted: taskEntity.isCompleted)
    }

    func toggleTaskCompletion(task: TaskDTO) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            let taskEntities = try context.fetch(fetchRequest)
            if let taskEntity = taskEntities.first {
                taskEntity.isCompleted.toggle()
                CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Failed to toggle task completion: \(error)")
        }
    }
}
