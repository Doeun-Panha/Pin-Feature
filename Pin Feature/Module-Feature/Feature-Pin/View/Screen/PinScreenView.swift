//
//  PinScreenView.swift
//  Pin Feature
//
//  Created by Panha on 13/10/26.
//

import SwiftUI

struct PinScreenView: View {
    var onDismiss: () -> Void
    var onSuccess: () -> Void
    
    @State private var viewModel: PinScreenViewModel = PinScreenViewModel()
    @State private var shakeOffset: CGFloat = 0
    
    let profileImageSize: CGFloat = 80
    let nameTextColor = "#ac9354"
//    let pinDotSize: CGFloat = 18
//    let keypadButtonSize: CGFloat = 65
    
    var body: some View {
        containerView
    }
}

extension PinScreenView {
    private var containerView: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isCompact = screenHeight < 670
            
            let backButtonIconSize = screenWidth * 0.05
            let backButtonPadding = screenWidth * 0.04
            
            let profileImageSize = screenWidth * 0.215
            let nameFontSize = screenWidth * 0.045
            let bodyFontSize = screenWidth * 0.038
            let pinDotSize = screenWidth * 0.05
            
            let keypadButtonSize = screenWidth * 0.175
            let keypadColumnSpacing = screenWidth * 0.11
            let keypadRowSpacing = screenHeight * 0.025
            let keypadBottomPadding = screenHeight * (isCompact ? 0.02 : 0.08)
            
            let actionButtonFontSize = screenWidth * 0.038
            let actionButtonPadding = screenWidth * 0.09
            
            ZStack(alignment: .top) {
                Color(hex: "162634")
                    .ignoresSafeArea()
                
                topNavigationView(
                    iconSize: backButtonIconSize,
                    padding: backButtonPadding
                )
                
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        profileSectionView(
                            imageSize: profileImageSize,
                            nameFontSize: nameFontSize,
                            bodyFontSize: bodyFontSize
                        )
                        
                        Spacer()
                        
                        pinRowView(
                            dotSize: pinDotSize,
                            bodyFontSize: bodyFontSize
                        )
                        
                        Spacer(minLength: 20)
                    }
                 
                    VStack(spacing: 0) {
                        Spacer()
                        
                        keypadView(
                            size: keypadButtonSize,
                            rowSpacing: keypadRowSpacing,
                            columnSpacing: keypadColumnSpacing
                        )
                        
                        Color.clear
                            .frame(height: keypadBottomPadding)
                        
                        bottomActionsView(
                            size: actionButtonFontSize,
                            padding: actionButtonPadding
                        )
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, screenHeight * 0.03)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        
        .onAppear {
            viewModel.onSuccessCallback = {
                onSuccess()
            }
            viewModel.loadProfile()
            
            Task {
                while true {
                    viewModel.errorTriggerCount = 0
                    try? await Task.sleep(for: .seconds(2))
                    viewModel.errorTriggerCount = 1
                    try? await Task.sleep(for: .seconds(2))
                }
            }
        }
        
        .onChange(of: viewModel.errorTriggerCount) { oldValue, newValue in
            guard newValue > 0 else { return }
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
                shakeOffset = 15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                shakeOffset = 0
            }
        }
        
    }
    
    private func topNavigationView(
        iconSize: CGFloat,
        padding: CGFloat
    ) -> some View {
        HStack {
            Button(action: {
                onDismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(padding)
                    .background(Circle().fill(Color.white.opacity(0.15)))
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .safeAreaPadding(.top, 5)
    }
    
    private func profileSectionView(
        imageSize: CGFloat,
        nameFontSize: CGFloat,
        bodyFontSize: CGFloat
    ) -> some View {
        VStack(spacing: 14) {
            VStack(spacing: 8) {
                profileImageView(imageSize: imageSize)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 0.5))
                
                Text(viewModel.displayName)
                    .font(.nunito(nameFontSize, weight: .semibold))
                    .foregroundStyle(Color(hex: nameTextColor))
            }
            
            Text(viewModel.displayPhone)
                .font(.nunito(bodyFontSize, weight: .medium))
                .foregroundStyle(.white)
            
            Text("Please Enter PIN")
                .font(.nunito(bodyFontSize, weight: .medium))
                .foregroundStyle(.white)
        }
//        .padding(.bottom, keypadBottomPadding)
    }
    
    @ViewBuilder
    private func profileImageView(imageSize: CGFloat) -> some View {
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
    
    private func pinRowView(
        dotSize: CGFloat,
        bodyFontSize: CGFloat
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ForEach(0..<viewModel.pinLength, id: \.self) { index in
                    Circle()
                        .stroke(Color.white, lineWidth: 0.75)
                        .frame(width: dotSize, height: dotSize)
                        .background(
                            Circle()
                                .fill(index < viewModel.enteredPin.count ? Color.white : Color.clear)
                        )
                }
            }
            
            if viewModel.errorTriggerCount > 0 {
                Text(viewModel.errorMessage)
                    .font(.nunito(bodyFontSize, weight: .medium))
                    .foregroundStyle(.red)
                    .padding(.bottom, 7)
                    .offset(x: shakeOffset)
                    .offset(y: 20)
            }
        }
    }
    
    private func keypadView(
        size: CGFloat,
        rowSpacing: CGFloat,
        columnSpacing: CGFloat
    ) -> some View {
        VStack(spacing: rowSpacing) {
            let rows = [
                ["1", "2", "3"],
                ["4", "5", "6"],
                ["7", "8", "9"],
                ["", "0", ""]
            ]
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: columnSpacing) {
                    ForEach(row, id: \.self) { digit in
                        if digit.isEmpty {
                            Color.clear
                                .frame(width: size, height: size)
                        } else {
                            keypadButton(label: digit, size: size) {
                                viewModel.appendDigit(digit)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func keypadButton(
        label: String,
        size: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: size * 0.42, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
    }
    
    private func bottomActionsView(
        size: CGFloat,
        padding: CGFloat
    ) -> some View {
        HStack {
            Button("Forget PIN") {
                viewModel.forgetPIN()
            }
            .font(.nunito(size, weight: .medium))
            .foregroundStyle(.white)
            
            Spacer()
            
            Button(viewModel.secondaryButtonTitle) {
                viewModel.handleSecondaryAction {
                    onDismiss()
                }
            }
            .font(.nunito(size, weight: .medium))
            .foregroundStyle(.white)
        }
        .padding(.horizontal, padding)
    }
}
