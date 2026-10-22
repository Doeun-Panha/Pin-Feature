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
    
    private let nameTextColor = "#ac9354"
    private let isDuo = UIDevice.current.name.localizedCaseInsensitiveContains("iPhone Duo")
    
    var body: some View {
        NavigationStack {
            containerView
                .navigationBarBackButtonHidden(true)
                .toolbar(isDuo ? .visible : .hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
        }
    }
}

extension PinScreenView {
    private var containerView: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let designAspect: CGFloat = 0.56
            let unit = min(screenWidth, screenHeight * designAspect)
            let isCompact = screenHeight < 670
            
            let backButtonIconSize = unit * 0.05
            let backButtonPadding = unit * 0.04
            
            let profileImageSize = unit * 0.215
            let nameFontSize = unit * 0.045
            let bodyFontSize = unit * 0.038
            let pinDotSize = unit * 0.05
            
            let keypadButtonSize = unit * 0.175
            let keypadColumnSpacing = unit * 0.11
            let keypadRowSpacing = screenHeight * 0.025
            let keypadBottomPadding = screenHeight * (isDuo ? 0.02 : (isCompact ? 0.02 : 0.08))
            
            let actionButtonFontSize = unit * 0.038
            let actionButtonPadding = unit * 0.09
            
            let contentSpacing = screenHeight * 0.02
            
            ZStack(alignment: .top) {
                if !isDuo {
                    topNavigationView(
                        iconSize: backButtonIconSize,
                        padding: backButtonPadding
                    )
                    .safeAreaPadding(.top, 5)
                }

                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    VStack(spacing: contentSpacing) {
                        profileSectionView(
                            imageSize: profileImageSize,
                            nameFontSize: nameFontSize,
                            bodyFontSize: bodyFontSize
                        )
                        
                        pinRowView(
                            dotSize: pinDotSize,
                            bodyFontSize: bodyFontSize,
                            spacing: contentSpacing
                        )
                    }

                    Spacer(minLength: 20)
                }
                .safeAreaPadding(.top, 5)
                .frame(maxWidth: unit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.errorTriggerCount)

                .safeAreaInset(edge: .bottom, spacing: 0) {
                    VStack(spacing: 0) {
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
                    .frame(maxWidth: unit)
                    .padding(.bottom, isDuo ? 0 : screenHeight * 0.03)
                }
            }
        }
        
        .background {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                
                Color(hex: "0D1926")
                    .opacity(0.65)
            }
            .ignoresSafeArea()
        }
        
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
        Image("profile-image")
            .resizable()
            .scaledToFill()
        
//        Image("nil-image-placeholder")
//            .resizable()
//            .scaledToFill()
    }
    
    private func pinRowView(
        dotSize: CGFloat,
        bodyFontSize: CGFloat,
        spacing: CGFloat
    ) -> some View {
        VStack(spacing: spacing) {
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
                    .offset(x: shakeOffset)
                    .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
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
