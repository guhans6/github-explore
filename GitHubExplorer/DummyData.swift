//
//  DummyJson.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import Foundation

struct DummyData: Codable, Identifiable {
    
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
