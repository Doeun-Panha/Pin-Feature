//
//  AppFont.swift
//  Pin Feature
//
//  Created by Panha on 26/10/26.
//

import SwiftUI
import UIKit

enum AppLanguage {
    case english
    case chinese
    case khmer
    case lao

    init(locale: Locale) {
        switch locale.language.languageCode?.identifier {
        case "km": self = .khmer
        case "lo": self = .lao
        case "zh": self = .chinese
        default:   self = .english
        }
    }
}

enum AppFont {
    static func uiFont(_ size: CGFloat, weight: Font.Weight, language: AppLanguage) -> UIFont {
        let name = fontName(for: language, weight: weight)

        if let font = UIFont(name: name, size: size) {
            return font
        }

        return .systemFont(ofSize: size)
    }

    static func font(_ size: CGFloat, weight: Font.Weight, language: AppLanguage) -> Font {
        Font(uiFont(size, weight: weight, language: language))
    }

    private static func fontName(for language: AppLanguage, weight: Font.Weight) -> String {
        switch language {
        case .english, .chinese: nunito(weight)
        case .khmer:             notoSansKhmer(weight)
        case .lao:               phetsarath(weight)
        }
    }

    private static func nunito(_ weight: Font.Weight) -> String {
        switch weight {
        case .ultraLight, .thin: "Nunito-ExtraLight"
        case .light:             "Nunito-Light"
        case .medium:            "Nunito-Medium"
        case .semibold:          "Nunito-SemiBold"
        case .bold:              "Nunito-Bold"
        case .heavy:             "Nunito-ExtraBold"
        case .black:             "Nunito-Black"
        default:                 "Nunito-Regular"
        }
    }

    private static func notoSansKhmer(_ weight: Font.Weight) -> String {
        switch weight {
        case .ultraLight: "NotoSansKhmer-Regular_ExtraLight"
        case .thin:       "NotoSansKhmer-Regular_Thin"
        case .light:      "NotoSansKhmer-Regular_Light"
        case .medium:     "NotoSansKhmer-Regular_Medium"
        case .semibold:   "NotoSansKhmer-Regular_SemiBold"
        case .bold:       "NotoSansKhmer-Regular_Bold"
        case .heavy:      "NotoSansKhmer-Regular_ExtraBold"
        case .black:      "NotoSansKhmer-Regular_Black"
        default:          "NotoSansKhmer-Regular"
        }
    }

    private static func phetsarath(_ weight: Font.Weight) -> String {
        switch weight {
        case .semibold, .bold, .heavy, .black: "Phetsarath-Bold"
        default:                               "Phetsarath-Regular"
        }
    }
}

private struct AppFontModifier: ViewModifier {
    @Environment(\.locale) private var locale

    let size: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content.font(
            AppFont.font(size, weight: weight, language: AppLanguage(locale: locale))
        )
    }
}

extension View {
    func appFont(_ size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(AppFontModifier(size: size, weight: weight))
    }
}
