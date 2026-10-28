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
    
    //Mock data
    var userProfile: PinScreenModel? = PinScreenModel(
        profileImageUrl: "nil-image-placeholder",
        name: "Doeun Panha",
        phone: "012 345 678"
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
        return enteredPin.isEmpty ? String(localized: "Cancel") : String(localized: "Delete")
    }
    
    var enteredPin: String = ""
    var errorTriggerCount: Int = 0
    
    //Mock error message
    let errorMessage = String(localized: "0085: Please Enter the Correct PIN")
    
    var onSuccessCallback: (() -> Void)?
}

extension PinScreenViewModel {
    func loadProfile() {
        //Load Profile Logic
    }
    
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
        //Mock Pin verifying logic
        if enteredPin == "111111" {
            onSuccessCallback?()
        } else {
            errorTriggerCount += 1
            enteredPin = ""
        }
        
        //Pin verifying logic
    }
    
    func forgetPIN() {
        //Forget Pin Logic
    }
    
    func handleSecondaryAction(onDismiss: () -> Void) {
        if enteredPin.isEmpty {
            onDismiss()
        } else {
            deleteDigit()
        }
    }
}
