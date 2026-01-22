//
//  String+Extension.swift
//  GitHubExplorer
//
//  Created by Guhan on 17/01/26.
//

import Foundation

extension Int {
    
    func formattedCompactString() -> String {
        self.formatted(
            .number
                .notation(.compactName)
                .precision(.fractionLength(0...1))
        )
    }
}
