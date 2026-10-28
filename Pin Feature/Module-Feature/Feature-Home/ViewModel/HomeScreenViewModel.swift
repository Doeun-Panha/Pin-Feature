//
//  HomeScreenViewModel.swift
//  Pin Feature
//
//  Created by Panha on 27/10/26.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class HomeScreenViewModel {
    var pinOpacity: Double = 0
    var isShowingPinScreen: Bool = false
    var isUnlocked: Bool = false
    var pose: DuoPose = .noHinge
    
    let pinFade: Animation = .easeInOut(duration: 0.45)
    
    var isUnfolded: Bool {
        pose == .partiallyOpen || pose == .fullyOpen
    }
}

extension HomeScreenViewModel {
    func showPin() {
        pinOpacity = 0
        isShowingPinScreen = true
        DispatchQueue.main.async {
            withAnimation(self.pinFade) {
                self.pinOpacity = 1
            }
        }
    }
    
    func hidePin() {
        withAnimation(pinFade) {
            pinOpacity = 0
        } completion: {
            self.isShowingPinScreen = false
        }
    }
    
    func onSuccess() {
        hidePin()
        isUnlocked = true
        // Additional OnSuccess Logic if needed
    }
}
