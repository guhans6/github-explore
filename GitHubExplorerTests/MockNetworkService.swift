//
//  MockNetworkService.swift
//  GitHubExplorerTests
//
//  Created by Guhan on 26/01/26.
//

import Foundation
@testable import GitHubExplorer

class MockNetworkService: NetworkServiceProtocol {
    
    var expectedUserDetailResponse: UserDetail?
    var errorToReturn: ErrorType?
    
    enum ErrorType: Error {
        case badURL, invalidResponse, unAuthorized, rateLimitExceeded
    }
    
    func fetchUserList(since: Int?) async throws -> [User] {
        throw URLError(.badServerResponse)
    }
    
    func getUserDetail(username: String) async throws -> UserDetail {
        if let errorToReturn {
            throw errorToReturn
        }
        
        if let expectedUserDetailResponse {
            return expectedUserDetailResponse
        }
        
        let user = User(id: 1, username: "defunkt", avatarURL: "https://google.com")
        let userDetails = UserDetail(user: user, name: "defunkt", email: "abc@test.com", bio: "I don't know a think", publicRepos: 10, followers: 11_000, following: 3)
        return userDetails
    }
    
    func fetchRepositories(for user: String) async throws -> [Repository] {
        throw URLError(.badServerResponse)
    }
    
    func searchUser(searchText: String) async throws -> SearchUserResponse {
        throw URLError(.badServerResponse)
    }
    
    
}
