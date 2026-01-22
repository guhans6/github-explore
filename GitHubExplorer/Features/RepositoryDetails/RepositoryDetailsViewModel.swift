//
//  RepositoryDetailsViewModel.swift
//  GitHubExplorer
//
//  Created by Guhan on 16/01/26.
//

import Foundation

@Observable
class RepositoryDetailsViewModel {
    
    let user: User
    let repository: Repository
    
    var descriptionText: String {
        repository.description ?? "No description provided"
    }
    
    init(user: User, repository: Repository) {
        self.user = user
        self.repository = repository
    }
}
