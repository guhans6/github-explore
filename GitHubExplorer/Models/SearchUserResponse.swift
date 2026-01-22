//
//  SearchUserResponse.swift
//  GitHubExplorer
//
//  Created by Guhan on 22/01/26.
//

import Foundation

struct SearchUserResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case users = "items"
    }
}
