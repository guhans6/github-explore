//
//  NetworkObserver.swift
//  GitHubExplorer
//
//  Created by Guhan on 31/01/26.
//

import Network
import Foundation

@Observable
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    var isConnected = true
    private let moniter = NWPathMonitor()
    
    private init() {
        moniter.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
            }
        }
        
        moniter.start(queue: DispatchQueue.global())
    }
}
