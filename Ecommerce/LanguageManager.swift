//
//  LanguageManager.swift
//  Ecommerce
//
//  Created by Daulet Yerkinov on 31.07.25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "app_language")
        }
    }
    
    init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: "app_language") ?? "ru"
    }
    
    func localizedString(_ key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    
    var isRussian: Bool {
        return currentLanguage == "ru"
    }
    
    var isEnglish: Bool {
        return currentLanguage == "en"
    }
    
    var currentLocale: Locale {
        return Locale(identifier: currentLanguage == "ru" ? "ru_RU" : "en_US")
    }
}

extension String {
    func localized(_ languageManager: LanguageManager) -> String {
        return languageManager.localizedString(self)
    }
}
