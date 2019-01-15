//
//  Translation.swift
//  OneSkyTest
//
//  Created by UHP Mac 3 on 15/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import CoreData

extension Translation: Persistable {
    
    static var identifierName: String {
        return "" // This entity does not have a specific identifier field. Instead, we differentiate it by key and locale.
    }
    
}
