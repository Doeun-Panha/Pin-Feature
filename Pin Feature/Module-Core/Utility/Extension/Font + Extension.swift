//
//  Font + Extension.swift
//  Pin Feature
//
//  Created by Panha on 13/10/26.
//

import SwiftUI

extension Font {
    static func nunito(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("Nunito", size: size).weight(weight)
    }
}
