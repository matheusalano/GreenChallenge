//
//  DateExtension.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import Foundation

extension Date {
    func toString(withStyle style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = style
        
        return dateFormatter.string(from: self)
    }
}
