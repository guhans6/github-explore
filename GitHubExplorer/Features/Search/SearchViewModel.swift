//
//  SearchViewModel.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import SwiftUI

@MainActor
@Observable
class SearchViewModel {
    
    let networkService: NetworkServiceProtocol
    var dummyData: [DummyData] = []
    var users: [User] = []
    var searchText: String = ""
    
    private var searchedUsers: [User] = []
    
    var searchTask: Task<Void, Never>?
    var sampleTask: Task<User, Error>?
    
    enum SearchState {
        case initial
        case loading
        case success([User])
        case error(String?)
    }
    var state: SearchState = .initial
    
    init(networkService: (any NetworkServiceProtocol)? = nil) {
        self.networkService = networkService ?? NetworkService()
    }
    
    func onSearchTextChange() {
        searchTask?.cancel()
        guard !searchText.isEmpty else {
            searchedUsers = []
            state = .initial
            return
        }
        
        state = .loading
        searchTask = Task {
            try? await Task.sleep(for: .microseconds(400))
            try? Task.checkCancellation()
            await searchUser()
        }
    }
    
    private func searchUser() async {
        do {
            let response = try await networkService.searchUser(searchText: searchText)
            searchedUsers = response.users
            state = .success(searchedUsers)
        } catch {
            print(error.localizedDescription)
            state = .error(nil)
        }
    }
    
    func fetchUserList() async {
        do {
            self.users = try await networkService.fetchUserList(since: nil)
        } catch {
            //Should update UI according to erro
            print(error.localizedDescription)
        }
    }
    
//    func searchUsers() {
//        guard !searchText.isEmpty else {
//            searchedUsers = [
//            return
//        }
//        
//        var users = self.users
//        users = users.filter { $0.username.localizedStandardContains(searchText)}
//        searchedUsers = users
//    }
}
