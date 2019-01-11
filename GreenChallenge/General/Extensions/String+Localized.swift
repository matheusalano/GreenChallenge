//
//  String+Localized.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation

extension String {
    static func localized(by key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
