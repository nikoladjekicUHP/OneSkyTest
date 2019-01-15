//
//  DictionaryExtensions.swift
//  OneSkyTest
//
//  Created by UHP Mac 3 on 15/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    var asDictionary: Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key : Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey) {
                dictionary[stringKey] = keyValue
            }
        }
        return dictionary
    }
}
