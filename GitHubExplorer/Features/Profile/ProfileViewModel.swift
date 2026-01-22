//
//  ProfileViewModel.swift
//  GitHubExplorer
//
//  Created by Guhan on 12/01/26.
//

import SwiftUI

@Observable
@MainActor
class ProfileViewModel {
    
    let user: User
    var userDetail: UserDetail?
    var isRepoListOpen: Bool = false
    
    private let networkService: any NetworkServiceProtocol
    
    var isLoading: Bool {
        userDetail == nil
    }
    
    init(user: User, networkService: (any NetworkServiceProtocol)? = nil) {
        self.user = user
        self.networkService = networkService ?? NetworkService()
    }
    
    func fetchUserDetails() async {
        do {
            self.userDetail = try await networkService.getUserDetail(username: user.username)
            print("Data Recieved")
        } catch {
            print("fetchUserDetails error \(error.localizedDescription)")
        }
    }
}
