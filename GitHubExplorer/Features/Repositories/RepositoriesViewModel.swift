//
//  RepositoriesViewModel.swift
//  GitHubExplorer
//
//  Created by Guhan on 16/01/26.
//

import Foundation

@Observable
class RepositoriesViewModel {
    
    var repositories: [Repository] = []
    var isLoading: Bool {
        repositories.isEmpty
    }
    let user: User
    private let networkService: any NetworkServiceProtocol
    
    
    init(user: User, networkService: (any NetworkServiceProtocol)? = nil) {
        self.user = user
        self.networkService = networkService ?? NetworkService()
    }
    
    func fetchRepositories() async {
        do {
            self.repositories = try await networkService.fetchRepositories(for: user.username)
        } catch {
            print("Fetch repos failed: \(error)")
        }
    }
    
    // Shows 1.2K for 1234, 1M for 1000000
    func starsText(for repo: Repository) -> String {
        let value = repo.stars
        return value.formattedCompactString()
    }
    
//    func starsText(for repo: Repository) -> String {
//        let value: Double = Double(repo.stars).rounded(.awayFromZero)
//
//        switch value {
//        case 1_000_000...:
//            return "\(value / 1_000_000)M"
//        case 1_000...:
//            return "\(value / 1_000)k"
//        default:
//             return "\(value)"
//        }
//    }
}
