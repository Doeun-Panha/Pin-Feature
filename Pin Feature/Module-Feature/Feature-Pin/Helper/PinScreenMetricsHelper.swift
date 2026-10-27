//
//  PinScreenMetricsHelper.swift
//  Pin Feature
//
//  Created by Panha on 27/10/26.
//
import SwiftUI

struct PinScreenMetricsHelper {
    private static let designAspect: CGFloat = 0.56
    private static let compactHeight: CGFloat = 670

    let height: CGFloat
    let unit: CGFloat
    let isDuo: Bool

    init(size: CGSize, isDuo: Bool) {
        self.height = size.height
        self.unit = min(size.width, size.height * Self.designAspect)
        self.isDuo = isDuo
    }

    private var isCompact: Bool { height < Self.compactHeight }

    var backIconSize: CGFloat { unit * 0.05 }
    var backButtonPadding: CGFloat { unit * 0.04 }

    var profileImageSize: CGFloat { unit * 0.215 }
    var nameFontSize: CGFloat { unit * 0.045 }
    var bodyFontSize: CGFloat { unit * 0.038 }
    var pinDotSize: CGFloat { unit * 0.05 }
    var contentSpacing: CGFloat { height * 0.02 }

    var keypadButtonSize: CGFloat { unit * 0.175 }
    var keypadColumnSpacing: CGFloat { unit * 0.11 }
    var keypadRowSpacing: CGFloat { height * 0.025 }
    var keypadBottomGap: CGFloat { height * ((isDuo || isCompact) ? 0.02 : 0.08) }

    var actionFontSize: CGFloat { unit * 0.038 }
    var actionHorizontalPadding: CGFloat { unit * 0.09 }
    var bottomInset: CGFloat { isDuo ? 0 : height * 0.03 }
}
