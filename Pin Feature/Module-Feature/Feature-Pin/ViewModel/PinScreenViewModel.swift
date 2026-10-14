//
//  PinScreenViewModel.swift
//  Pin Feature
//
//  Created by Panha on 13/10/26.
//

import Observation
import Foundation
import SwiftUI

@MainActor
@Observable
final class PinScreenViewModel {
    let pinLength = 6
    
    var userProfile: PinScreenModel? = PinScreenModel(
        profileImageUrl: "nil-image-placeholder",
        name: "Name not Loaded",
        phone: "XXX XXX XXX"
    )
    
    var profileImageURL: URL? {
        guard let urlString = userProfile?.profileImageUrl, urlString != "nil-image-placeholder", let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var displayName: String {
        return (userProfile?.name ?? "Name not Loaded").uppercased()
    }
    
    var displayPhone: String {
        return userProfile?.phone ?? "XXX XXX XXX"
    }
    
    var profileImageURLString: String {
        return userProfile?.profileImageUrl ?? "nil-image-placeholder"
    }
    
    var secondaryButtonTitle: String {
        return enteredPin.isEmpty ? "Cancel" : "Delete"
    }
    
    var enteredPin: String = ""
    var isError: Bool = false
    let errorMessage = "0085: Please Enter the Correct PIN"
}

extension PinScreenViewModel {
    func appendDigit(_ digit: String) {
        guard enteredPin.count < pinLength else { return }
        enteredPin.append(digit)
        
        if enteredPin.count == pinLength {
            handlePinCompletion()
        }
    }
    
    func deleteDigit() {
        guard !enteredPin.isEmpty else { return }
        enteredPin.removeLast()
    }
    
    private func handlePinCompletion() {
        let requestPayload = PinVerifyRequest(pin: enteredPin)
        
//        Task {
//            do {
//                
//            } catch {
//                isError = true
//                enteredPin = ""
//            }
//        }
    }
    
    func simulateError() {
        isError = !isError

    }
    
    func handleSecondaryAction(onDismiss: () -> Void) {
        if enteredPin.isEmpty {
            onDismiss()
        } else {
            deleteDigit()
        }
    }
    
    func forgetPIN() {
        
    }
}
