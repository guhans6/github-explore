//
//  Repository.swift
//  GitHubExplorer
//
//  Created by Guhan on 16/01/26.
//

import Foundation

struct Repository: Identifiable, Decodable, Hashable {
    
    let id: Int
    let name: String
    let description: String?
    let stars, forks, watchers: Int
    let language: String?
    let defaultBranch: String
    let visibility: String
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case stars = "stargazers_count"
        case forks = "forks_count"
        case language, watchers
        case defaultBranch = "default_branch"
        case visibility
        case createdAt = "createdAt"
        case updatedAt = "updated_at"
        
        
    }
}
