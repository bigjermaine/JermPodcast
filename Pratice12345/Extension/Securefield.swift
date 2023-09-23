//
//  Securefield.swift
//  Pratice12345
//
//  Created by MacBook AIR on 20/09/2023.
//

import Foundation

extension String {
    func toSecureHttps() -> String {
        return self.contains("https") ? self :
        self.replacingOccurrences(of: "http", with: "https")
    }
}
