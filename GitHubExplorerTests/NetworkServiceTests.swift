//
//  NetworkServiceTests.swift
//  GitHubExplorerTests
//
//  Created by Guhan on 26/01/26.
//

import XCTest
@testable import GitHubExplorer

@MainActor
final class NetworkServiceTests: XCTestCase {
    
    var sut: ProfileViewModel!
    var mockService: MockNetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let user = User(id: 101, username: "user_test", avatarURL: "https://google.com")
        mockService = MockNetworkService()
        sut = ProfileViewModel(user: user, networkService: mockService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    func testFetchUserDetails() async throws {
        //Arrange
        let expectedUser = User(id: 1001, username: "user_test", avatarURL: "https://google.com")
        let expectedUserDetail = UserDetail(user: expectedUser, name: "Test User", email: "user@test.com", bio: "I don't know a think", publicRepos: 100, followers: 12_000, following: 5)
        mockService.errorToReturn = nil
        mockService.expectedUserDetailResponse = expectedUserDetail
        
        //Act
        await sut.fetchUserDetails()
        
        //Assert
        if case .success(let userDetail) = sut.profileState {
            XCTAssertEqual(userDetail.user.username, expectedUser.username)
        } else {
            XCTFail("Expected success state but returned \(sut.profileState)")
        }
    }
    
//    private func test_onSearchTextChange_noResults
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
}
