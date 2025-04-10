//
//  CoreDataManager.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUser(name: String, email: String, photoURL: String) {
        if doesUserExist(email: email, context: context) {
            print("User already exists.")
        } else {
            let user = BookxpertTask.CDUser(context: context)
            user.name = name
            user.email = email
            user.photoURL = photoURL
            
            do {
                try context.save()
                print("User saved to Core Data")
            } catch {
                print("Failed to save user:", error.localizedDescription)
            }
        }
    }
    
    func fetchUsers() -> [BookxpertTask.CDUser] {
        let fetchRequest: NSFetchRequest<BookxpertTask.CDUser> = BookxpertTask.CDUser.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Fetch error:", error.localizedDescription)
            return []
        }
    }
    
    func doesUserExist(email: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser") // Replace "User" with your entity name
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if user exists: \(error.localizedDescription)")
            return false
        }
    }
    
    func saveItem(id: String, name: String, createdAt: Date) {
           let newItem = APIItem(context: context)
           newItem.id = id
           newItem.name = name
           newItem.createdAt = createdAt
           saveContext()
       }

    func fetchItems() -> [APIItem] {
        let request: NSFetchRequest<APIItem> = APIItem.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    func deleteItem(item: APIItem) {
        context.delete(item)
        saveContext()
    }
    
    func updateItem(item: APIItem, newName: String) {
        item.name = newName
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Saving Core Data failed: \(error)")
        }
    }
}
