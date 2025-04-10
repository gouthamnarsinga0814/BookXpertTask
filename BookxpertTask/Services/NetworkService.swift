//
//  NetworkService.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import Foundation
import Network

class NetworkService {
    static let shared = NetworkService()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
            print("Network connectivity: \(self.isConnected ? "Available" : "Unavailable")")
        }
        monitor.start(queue: queue)
    }

    func fetchAPIData(completion: @escaping ([APIItemModel]?) -> Void) {
        guard let url = URL(string: Constants.objectAPI) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("API fetch error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let items = try JSONDecoder().decode([APIItemModel].self, from: data)
                completion(items)
            } catch {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
