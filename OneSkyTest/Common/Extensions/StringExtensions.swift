//
//  StringExtensions.swift
//  OneSkyTest
//
//  Created by UHP Mac 1 on 14/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
