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
    
    enum ProfileFetchState {
        case initial
        case loading
        case success(UserDetail)
        case error(String)
    }
    
    var profileState: ProfileFetchState = .initial
    var isProfileLoading: Bool {
        if case .loading = profileState {
            return true
        }
        return false
    }
    
    var user: User?
    var userDetail: UserDetail?
    var isRepoListOpen: Bool = false
    
    private let networkService: any NetworkServiceProtocol
    
    init(networkService: (any NetworkServiceProtocol)? = nil) {
        self.networkService = networkService ?? NetworkService()
    }
    
    func fetchUserDetails(for user: User) async {
        profileState = .loading
        self.user = user
        do {
            let userDetail = try await networkService.getUserDetail(username: user.username)
            self.userDetail = userDetail
            self.profileState = .success(userDetail)
        } catch let error as NetworkError {
            profileState = .error(error.localizedDescription)
        } catch is CancellationError {
            return
        } catch {
            print(error.localizedDescription)
            profileState = .error("An unexpected error has occured")
        }
    }
}
