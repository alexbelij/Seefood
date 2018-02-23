//
//  SettingsBundleHelper.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/22/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let RestrictiveSuggestion = "restrictive_suggestions"
        static let Version = "version"
    }
    
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.RestrictiveSuggestion) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.RestrictiveSuggestion)
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        }
    }
    
    class func setVersion() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
    }
    
}
