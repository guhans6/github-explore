//
//  Endpoint.swift
//  GitHubExplorer
//
//  Created by Guhan on 12/01/26.
//

import Foundation

enum GitHubEndpoint {
    
    private static let users = "/users"
    private static let repos = "/repos"
    
    case listUsers(since: Int?)
    case user(user: String)
    case searchUsers(query: String) //MARK: Not implemented
    case listRepos(user: String)
    
    
    private var path: String {
        switch self {
        case .listUsers:
            return Self.users
        case .user(let user):
            return Self.users.appending("/\(user)")
        case .searchUsers:
            return "/search".appending(Self.users)
        case .listRepos(let user):
            return Self.user(user: user).path.appending(Self.repos)
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .listUsers(let since):
            guard let since else { return nil }
            return [
                URLQueryItem(name: "since", value: String(since)),
            ]
        case .searchUsers(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "per_page", value: "30")
            ]
        default:
            return nil
        }
    }
    
    func url() -> URL? {
        var components = URLComponents(url: APIConfig.baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
