//
//  String+Extension.swift
//  GitHubExplorer
//
//  Created by Guhan on 17/01/26.
//

import Foundation

extension String {
    
    func formattedDisplayDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return "-" }
        
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
