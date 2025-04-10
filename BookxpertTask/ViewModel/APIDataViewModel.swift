//
//  APIDataViewModel.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import Foundation

class APIDataViewModel {
    var items: [APIItem] = []

    func fetchFromAPI(completion: @escaping () -> Void) {
        NetworkService.shared.fetchAPIData { [weak self] models in
            guard let models = models else { return }
            DispatchQueue.main.async {
                models.forEach {
                    CoreDataManager.shared.saveItem(id: $0.id, name: $0.name, createdAt: Date())
                }
                self?.items = CoreDataManager.shared.fetchItems()
                completion()
            }
        }
        
    }

    func fetchLocalData() {
        items = CoreDataManager.shared.fetchItems()
    }

    func deleteItem(_ item: APIItem) {
        CoreDataManager.shared.deleteItem(item: item)
        items = CoreDataManager.shared.fetchItems()
    }

    func updateItem(_ item: APIItem, name: String) {
        CoreDataManager.shared.updateItem(item: item, newName: name)
        items = CoreDataManager.shared.fetchItems()
    }
}

