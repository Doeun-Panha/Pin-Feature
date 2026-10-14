//
//  ContentView.swift
//  Pin Feature
//
//  Created by Panha on 13/10/26.
//

import SwiftUI

struct PinScreenView: View {
    var onDismiss: () -> Void
    var onSuccess: () -> Void
    
    @State private var viewModel: PinScreenViewModel = PinScreenViewModel()
    
    let profileImageSize: CGFloat = 80
    let nameTextColor = "#ac9354"
    let pinDotSize: CGFloat = 18
    let keypadButtonSize: CGFloat = 65
    
    var body: some View {
        containerView
    }
}

extension PinScreenView {
    private var containerView: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(hex: "162634")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    profileSectionView
                    
                    pinRowView
                    
                    Spacer()
                        .frame(height: 42)
                    
                    VStack(spacing: 64) {
                        keypadView
                        
                        bottomActionsView
                    }
                }
                .padding(.horizontal)
                
                topNavigationView
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.onSuccessCallback = {
                onSuccess()
            }
            viewModel.loadProfile()
        }
    }
    
    private var topNavigationView: some View {
        HStack {
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(Circle().fill(Color.white.opacity(0.15)))
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .safeAreaPadding(.top, 5)
    }
    
    private var profileSectionView: some View {
        VStack(spacing: 14) {
            VStack(spacing: 10) {
                profileImageView
                    .frame(width: profileImageSize, height: profileImageSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
                
                Text(viewModel.displayName)
                    .font(.nunito(18, weight: .medium))
                    .foregroundStyle(Color(hex: nameTextColor))
            }
            
            Text(viewModel.displayPhone)
                .font(.nunito(15, weight: .regular))
                .foregroundStyle(.white)
            
            Text("Please Enter PIN")
                .font(.nunito(15, weight: .regular))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        if let url = viewModel.profileImageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    fallbackImageView
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure(_):
                    fallbackImageView
                    
                @unknown default:
                    fallbackImageView
                }
            }
        } else {
            fallbackImageView
        }
    }
    
    private var fallbackImageView: some View {
        //Temp Profile image
        Image("profile-image")
            .resizable()
            .scaledToFill()
        
//        Image("nil-image-placeholder")
//            .resizable()
//            .scaledToFill()
    }
    
    private var pinRowView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ForEach(0..<viewModel.pinLength, id: \.self) { index in
                    Circle()
                        .stroke(Color.white, lineWidth: 0.75)
                        .frame(width: pinDotSize, height: pinDotSize)
                        .background(
                            Circle()
                                .fill(index < viewModel.enteredPin.count ? Color.white : Color.clear)
                        )
                }
            }
            
            if(viewModel.isError) {
                Text(viewModel.errorMessage)
                    .font(.nunito(15, weight: .regular))
                    .foregroundStyle(.red)
                    .offset(y: 20)
                    .padding(.bottom, 7)
            }
        }
    }
    
    private var keypadView: some View {
        VStack(spacing: 18) {
            let rows = [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"],
                ["0"]
            ]
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 45) {
                    if row.count > 1 {
                        ForEach(row, id: \.self) { digit in
                            keypadButton(label: digit) {
                                viewModel.appendDigit(digit)
                            }
                        }
                    } else {
                        Spacer()
                        
                        keypadButton(label: row[0]) {
                            viewModel.appendDigit(row[0])
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func keypadButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: keypadButtonSize, height: keypadButtonSize)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
    }
    
    private var bottomActionsView: some View {
        HStack {
            Button("Forget PIN") {
//                viewModel.forgetPIN()
                viewModel.simulateError()
            }
            .font(.nunito(15, weight: .regular))
            .foregroundStyle(.white)
            
            Spacer()
            
            Button(viewModel.secondaryButtonTitle) {
                viewModel.handleSecondaryAction {
                    onDismiss()
                }
            }
            .font(.nunito(15, weight: .regular))
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 34)
        .safeAreaPadding(.bottom, 19)
    }
}
