//
//  Persistable.swift
//  OneSkyTest
//
//  Created by UHP Mac 3 on 15/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import CoreData

protocol Persistable where Self:NSManagedObject {
    
    static var identifierName: String { get }
    
}
