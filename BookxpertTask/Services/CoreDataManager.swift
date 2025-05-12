//
//  CoreDataManager.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import CoreData
import UIKit
import UserNotifications

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
    
    func saveItem(id: String, name: String, data: [String: CodableValue], createdAt: Date) {
           let newItem = APIItem(context: context)
           newItem.id = id
           newItem.name = name
           newItem.createdAt = createdAt
        
        // Convert CodableValue to plain [String: Any]
           let plainData = convertCodableValueDictToPlain(data)
           if let jsonData = try? JSONSerialization.data(withJSONObject: plainData, options: []) {
               newItem.data = jsonData
           }
        
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
        sendDeletionNotification(for: item)
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
    
    func convertCodableValueDictToPlain(_ input: [String: CodableValue]) -> [String: Any] {
        var output: [String: Any] = [:]
        for (key, value) in input {
            switch value {
            case .string(let str): output[key] = str
            case .int(let i): output[key] = i
            case .double(let d): output[key] = d
            case .dictionary(let dict): output[key] = convertCodableValueDictToPlain(dict)
            }
        }
        return output
    }
    
    private func sendDeletionNotification(for item: APIItem) {
        let content = UNMutableNotificationContent()
        content.title = "Item Deleted"
        content.body = "\(item.name ?? "") deleted successfully"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
}
