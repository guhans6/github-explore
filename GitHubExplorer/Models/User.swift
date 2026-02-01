//
//  User.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import Foundation

struct User: Decodable, Identifiable, Hashable {
    let id: Int
    let username: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarURL = "avatar_url"
    }
}

struct UserDetail: Decodable {
    let user: User
    let name: String?
    let email, bio: String?
    let publicRepos, followers, following: Int

    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatarURL = "avatar_url"
        case name, email, bio
        case publicRepos = "public_repos"
        case followers, following
    }
    
    init(user: User, name: String?, email: String?, bio: String?, publicRepos: Int, followers: Int, following: Int) {
        self.user = user
        self.name = name
        self.email = email
        self.bio = bio
        self.publicRepos = publicRepos
        self.followers = followers
        self.following = following
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let username = try container.decode(String.self, forKey: .username)
        let avatarURL = try container.decode(String.self, forKey: .avatarURL)

        self.user = User(id: id, username: username, avatarURL: avatarURL)

        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.publicRepos = try container.decode(Int.self, forKey: .publicRepos)
        self.followers = try container.decode(Int.self, forKey: .followers)
        self.following = try container.decode(Int.self, forKey: .following)
    }
    
    
    //MARK: IF NEED ENCODING YOU MUST IMPLEMENT THIS
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(user.id, forKey: .id)
//        try container.encode(user.username, forKey: .username)
//        try container.encode(user.avatarURL, forKey: .avatarURL)
//        
//        try container.encodeIfPresent(name, forKey: .name)
//        try container.encodeIfPresent(email, forKey: .email)
//        try container.encodeIfPresent(bio, forKey: .bio)
//        try container.encode(publicRepos, forKey: .publicRepos)
//        try container.encode(followers, forKey: .followers)
//        try container.encode(following, forKey: .following)
//    }
}


struct MockData {
    static let user = User(id: 1,
                           username: "defunkt",
                           avatarURL: "https://avatars.githubusercontent.com/u/2?v=4")
    
    static let repo = Repository(id: 1, name: "open-llm", description: "GUI to all open source LLM models", stars: 8, forks: 4, watchers: 10, language: "CSS", defaultBranch: "gh-pages", visibility: "public", createdAt: "2014-11-20T06:42:47Z", updatedAt: "2023-11-29T23:19:06Z")
}
