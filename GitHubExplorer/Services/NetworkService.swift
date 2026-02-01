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

enum NetworkError: Error, LocalizedError { //TODO: Put this in seperate file
    
    case unknown
    case invalidURL
    case decodingError
    case offline
    case serverError
    case unAuthorized
    case noDataError
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong"
        case .invalidURL:
            return "The URL was invalid"
        case .decodingError:
            return "Error while parsing"
        case .offline:
            return "No internet connection. Please check your connection"
        case .serverError:
            return "Oops! server having some issues. Try again later"
        case .unAuthorized:
            return "Unautherized, you don't have permission to see this"
        case .noDataError:
            return "No data returned from server"
        }
    }
}

final class NetworkService: NetworkServiceProtocol {
    
    
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
        guard let url else { throw NetworkError.invalidURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            // Can check response for code if it is good or bad code like 401 etc.
            // Error handling should be done
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError
                } else if httpResponse.statusCode == 401 {
                    throw NetworkError.unAuthorized
                }
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch let error as URLError {
            switch error.code {
            case .cancelled:
                throw CancellationError()
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.offline
            case .badURL:
                throw NetworkError.invalidURL
            case .timedOut:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
        } catch {
            throw NetworkError.unknown
        }
    }
}
