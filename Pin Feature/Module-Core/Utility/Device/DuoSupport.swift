//
//  DuoSupport.swift
//  Pin Feature
//
//  Created by Panha on 23/10/26.
//

import SwiftUI

enum DeviceInfo {
    static let isDuo = UIDevice.current.name.localizedCaseInsensitiveContains("iPhone Duo")
}

enum DuoPose {
    case noHinge
    case closed
    case partiallyOpen
    case fullyOpen
}

struct HingeTracker: ViewModifier {
    @Binding var pose: DuoPose

    func body(content: Content) -> some View {
        if #available(anyAppleOS 27.1, *) {
            content.onHingeChange { _, context in
                guard let hinge = context.hinge else {
                    pose = .noHinge
                    return
                }

                switch hinge.status {
                case .closed:        pose = .closed
                case .partiallyOpen: pose = .partiallyOpen
                case .fullyOpen:     pose = .fullyOpen
                default:             break
                }
            }
        } else {
            content
        }
    }
}
