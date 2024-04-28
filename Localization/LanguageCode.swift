enum LanguageCode: String, CaseIterable {
    case en = "English"
    case zh = "简体中文"
    case tw = "繁體中文"
}

extension LanguageCode {
    private static let traditionalChinese = "Hant"

    static func fetchPreferredLanguegeCode() -> LanguageCode {
        let languages = LanguageCode.AllCases()
        guard let preferredLanguage = Locale.preferredLanguages.first,
              let code = preferredLanguage.components(separatedBy: "-").first,
              var language = languages.first(where: { $0.rawValue == code }) else { return .en }
        if language == .zh {
            if preferredLanguage.components(separatedBy: "-")[1] == traditionalChinese {
                language = .tw
            }
        }
        return language
    }

    static func settingLanguage(by languageCode: LanguageCode) -> LocalizationProtocol {
        switch languageCode {
            case .en: Localization()
            case .zh: LocalizationZH()
            case .tw: LocalizationTW()
        }
    }
}
