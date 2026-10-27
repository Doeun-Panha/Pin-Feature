//
//  PinScreenSmoothSizedHelper.swift
//  Pin Feature
//
//  Created by Panha on 27/10/26.
//
import SwiftUI

struct PinScreenSmoothSizedHelper<Content: View>: View, Animatable {
    var size: CGSize
    private let content: (CGSize) -> Content

    init(size: CGSize, @ViewBuilder content: @escaping (CGSize) -> Content) {
        self.size = size
        self.content = content
    }

    var animatableData: CGSize.AnimatableData {
        get { size.animatableData }
        set { size.animatableData = newValue }
    }

    var body: some View { content(size) }
}
