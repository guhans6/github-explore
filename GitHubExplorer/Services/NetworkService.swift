//
//  NetworkService.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import Foundation

protocol NetworkServiceProtocol {
    
    //This should be in seperate protocols right?
    func fetchUserList(since: Int?) async throws -> [User]
    func getUserDetail(username: String) async throws -> UserDetail
    func fetchRepositories(for user: String) async throws -> [Repository]
    func searchUser(searchText: String) async throws -> SearchUserResponse
}

class NetworkService: NetworkServiceProtocol {
    
    
    func fetchUserList(since: Int? = nil) async throws -> [User] {
        let url = GitHubEndpoint.listUsers(since: since).url()
        return try await request(with: url)
    }
    
    func searchUser(searchText: String) async throws -> SearchUserResponse {
        let url = GitHubEndpoint.searchUsers(query: searchText).url()
        return try await request(with: url)
    }
    
    func getUserDetail(username: String) async throws -> UserDetail {
        let url = GitHubEndpoint.user(user: username).url()
        return try await request(with: url)
    }
    
    func fetchRepositories(for user: String) async throws -> [Repository] {
        let url = GitHubEndpoint.listRepos(user: user).url()
        return try await request(with: url)
    }
    
    //This method should be the only one present in this class but for practice this is okay
    private func request<T: Decodable>(with url: URL?) async throws -> T {
        guard let url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        // Can check response for code if it is good or bad code like 401 etc.
        // Error handling should be done
        if let httpResponse = response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
