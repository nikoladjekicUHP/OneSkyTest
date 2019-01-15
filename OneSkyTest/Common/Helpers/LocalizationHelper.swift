//
//  LocalizationManager.swift
//  OneSkyTest
//
//  Created by UHP Mac 3 on 15/01/2019.
//  Copyright © 2019 UHP Mac 1. All rights reserved.
//

import Foundation

final class LocalizationHelper {
    
    static let instance = LocalizationHelper(coreDataHelper: CoreDataHelper.instance)
    
    private let coreDataHelper: CoreDataHelper
    
    init(coreDataHelper: CoreDataHelper) {
        self.coreDataHelper = coreDataHelper
    }
    
    func getTranslation(key: String, locale: String = Constants.defaultLocale) -> String? {
        return getTranslationObject(key: key, locale: locale)?.value
    }
    
    func getTranslationObject(key: String, locale: String = Constants.defaultLocale) -> Translation? {
        let keyPredicate = NSPredicate(format: "key = %@", key)
        let localePredicate = NSPredicate(format: "locale = %@", locale)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [keyPredicate, localePredicate])
        return coreDataHelper.getObjectBy(Translation.self, predicate: predicate)
    }
    
    func saveTranslation(key: String, value: String, locale: String = Constants.defaultLocale) {
        let translation = getNewOrExisting(key: key, locale: locale)
        translation.key = key
        translation.value = value
        translation.locale = locale
    }
    
    func saveLocalizationDictionary(_ dict: NSDictionary, locale: String = Constants.defaultLocale) {
        let dictionary = dict.asDictionary
        
        for (key, value) in dictionary {
            saveTranslation(key: key, value: value as! String, locale: locale)
        }
        
        coreDataHelper.saveContext()
    }
    
    private func getNewOrExisting(key: String, locale: String = Constants.defaultLocale) -> Translation {
        var object = getTranslationObject(key: key, locale: locale)
        if object == nil {
            object = coreDataHelper.create(type: Translation.self)
        }
        return object!
    }
    
}
