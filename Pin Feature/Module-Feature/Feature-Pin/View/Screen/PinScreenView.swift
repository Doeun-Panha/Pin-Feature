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
    
    @State private var viewModel = PinScreenViewModel()
    
    @State private var shakeOffset: CGFloat = 0
    @State private var pose: DuoPose = .noHinge
    
    private let isDuo = DeviceInfo.isDuo
    private var isPartiallyOpen: Bool { pose == .partiallyOpen }
    private var isFullyOpen: Bool { pose == .fullyOpen }
    
    private let nameTextColor = "#ac9354"
    private let layoutAnimation: Animation = .smooth(duration: 0.45)
    
    var body: some View {
        content
    }
}

extension PinScreenView {
    private var content: some View {
        pinLayout
            .ignoresSafeArea(.container, edges: isDuo ? .horizontal : [])
            .background { backgroundView }
            .modifier(HingeTracker(pose: $pose))
            .onAppear{ setup() }
            .onChange(of: viewModel.errorTriggerCount) { _, newValue in
                guard newValue > 0 else { return }
                playErrorFeedback()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(isDuo ? .visible : .hidden, for: .navigationBar)
            .toolbar {
                if isDuo {
                    backToolbarItem
                }
            }
    }

    private var pinLayout: some View {
        GeometryReader { geometry in
            if geometry.size.width > 0, geometry.size.height > 0 {
                let fullWidth = geometry.size.width
                let useLeftHalf = isDuo && isPartiallyOpen && fullWidth > geometry.size.height

                PinScreenSmoothSizedHelper(size: geometry.size) { size in
                    let m = PinScreenMetricsHelper(size: size, isDuo: isDuo)

                    ZStack(alignment: .top) {
                        if !isDuo {
                            customBackButton(m)
                        }

                        upperSection(m)
                            .safeAreaInset(edge: .bottom, spacing: 0) {
                                lowerSection(m)
                            }
                    }
                }
                .offset(x: useLeftHalf ? -fullWidth / 4 : 0)
                .animation(layoutAnimation, value: useLeftHalf)
            }
        }
    }

    private func upperSection(_ m: PinScreenMetricsHelper) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            VStack(spacing: m.contentSpacing) {
                profileSectionView(m)
                pinRowView(m)
            }

            Spacer(minLength: 20)
        }
        .safeAreaPadding(.top, 5)
        .frame(maxWidth: m.unit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.spring(response: 0.3, dampingFraction: 1), value: viewModel.errorTriggerCount)
    }

    private func lowerSection(_ m: PinScreenMetricsHelper) -> some View {
        VStack(spacing: 0) {
            keypadView(m)

            Color.clear
                .frame(height: m.keypadBottomGap)

            bottomActionsView(m)
        }
        .frame(maxWidth: m.unit)
        .padding(.bottom, m.bottomInset)
    }
}

extension PinScreenView {
    private var backgroundView: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)

            Color(hex: "0D1926")
                .opacity(0.65)
        }
        .ignoresSafeArea()
    }

    private func setup() {
        viewModel.onSuccessCallback = { onSuccess() }
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

    private func playErrorFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)

        withAnimation(.spring(response: 0.2, dampingFraction: 0.2)) {
            shakeOffset = 15
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            shakeOffset = 0
        }
    }
}

extension PinScreenView {
    private var backToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
            }
        }
    }

    private func customBackButton(_ m: PinScreenMetricsHelper) -> some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: m.backIconSize, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(m.backButtonPadding)
                    .background(Circle().fill(Color.white.opacity(0.15)))
            }

            Spacer()
        }
        .padding(.horizontal)
        .safeAreaPadding(.top, 5)
    }
}

extension PinScreenView {
    private func profileSectionView(_ m: PinScreenMetricsHelper) -> some View {
        VStack(spacing: 14) {
            VStack(spacing: 8) {
                profileImageView
                    .frame(width: m.profileImageSize, height: m.profileImageSize)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 0.5))

                Text(viewModel.displayName)
                    .appFont(m.nameFontSize, weight: .semibold)
                    .foregroundStyle(Color(hex: nameTextColor))
            }

            Text(viewModel.displayPhone)
                .appFont(m.bodyFontSize, weight: .medium)
                .foregroundStyle(.white)

            Text("Please Enter PIN")
                .appFont(m.bodyFontSize, weight: .medium)
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    private var profileImageView: some View {
        if let url = viewModel.profileImageURL {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    fallbackImageView
                }
            }
        } else {
            fallbackImageView
        }
    }

    private var fallbackImageView: some View {
        //Mock profile image. Swap to "nil-image-placeholder" for the correct fallback image placeholder
        Image("profile-image")
            .resizable()
            .scaledToFill()
    }

    private func pinRowView(_ m: PinScreenMetricsHelper) -> some View {
        VStack(spacing: m.contentSpacing) {
            HStack(spacing: 16) {
                ForEach(0..<viewModel.pinLength, id: \.self) { index in
                    Circle()
                        .stroke(Color.white, lineWidth: 0.75)
                        .frame(width: m.pinDotSize, height: m.pinDotSize)
                        .background(
                            Circle()
                                .fill(index < viewModel.enteredPin.count ? Color.white : Color.clear)
                        )
                }
            }

            if viewModel.errorTriggerCount > 0 {
                Text(viewModel.errorMessage)
                    .appFont(m.bodyFontSize, weight: .medium)
                    .foregroundStyle(.red)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .offset(x: shakeOffset)
                    .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
            }
        }
    }
}

extension PinScreenView {
    private static let keypadRows: [[String?]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [nil, "0", nil]
    ]

    private func keypadView(_ m: PinScreenMetricsHelper) -> some View {
        VStack(spacing: m.keypadRowSpacing) {
            ForEach(Array(Self.keypadRows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: m.keypadColumnSpacing) {
                    ForEach(Array(row.enumerated()), id: \.offset) { _, digit in
                        if let digit {
                            keypadButton(label: digit, size: m.keypadButtonSize) {
                                viewModel.appendDigit(digit)
                            }
                        } else {
                            Color.clear
                                .frame(width: m.keypadButtonSize, height: m.keypadButtonSize)
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
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
    }

    private func bottomActionsView(_ m: PinScreenMetricsHelper) -> some View {
        HStack {
            Button("Forget PIN") {
                viewModel.forgetPIN()
            }

            Spacer()

            Button(viewModel.secondaryButtonTitle) {
                viewModel.handleSecondaryAction {
                    onDismiss()
                }
            }
        }
        .appFont(m.actionFontSize, weight: .medium)
        .foregroundStyle(.white)
        .padding(.horizontal, m.actionHorizontalPadding)
    }
}


