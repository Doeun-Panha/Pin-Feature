//
//  HomeScreenView.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var showPinScreen: Bool = true
    @State private var pose: DuoPose = .noHinge
    
    private let isDuo = DeviceInfo.isDuo
    
    private var isUnfolded: Bool {
        pose == .partiallyOpen || pose == .fullyOpen
    }
    
    var body: some View {
        container
            .modifier(HingeTracker(pose: $pose))
    }
}

extension HomeScreenView {
    private var container: some View {
        NavigationStack {
            ZStack {
                Color(hex: "093558")
                    .ignoresSafeArea()
                
                background
                
//                showPinTapArea
                
                pinLayer
            }
            .toolbar {
                if !showPinScreen {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: showPin) {
                            Image(systemName: "lock.open")
                        }
                    }
                    
                    if #available(iOS 26.0, *) {
                        ToolbarSpacer(.fixed, placement: .topBarLeading)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: showPin) {
                            Image("khmer-flag-image")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var background: some View {
        if isDuo, #available(anyAppleOS 27.1, *) {
            duoBackground
        } else {
            homeImage(.fill)
        }
    }
    
    @available(anyAppleOS 27.1, *)
    @ViewBuilder
    private var duoBackground: some View {
        if isUnfolded {
            ArrangementView {
                homeImage(.fit)
            } secondary: {
                homeImage(.fit)
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        } else {
            homeImage(.fit)
        }
    }
    
    private func homeImage(_ contentMode: ContentMode) -> some View {
        Color(hex: "093558")
//            .background {
//                Image("dummy-homeScreenView-Image")
//                    .resizable()
//                    .aspectRatio(contentMode: contentMode)
//                
//            }
            .ignoresSafeArea()
    }
}

extension HomeScreenView {
    private var showPinTapArea: some View {
        Button(action: showPin) {
            Color.clear
        }
        .contentShape(Rectangle())
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var pinLayer: some View {
        if showPinScreen {
            PinScreenView(
                onDismiss: onDismiss,
                onSuccess: onSuccess
            )
            .transition(.opacity)
            .zIndex(1)
        }
    }
    
    private func showPin() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showPinScreen = true
        }
    }
    
    private func onDismiss() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showPinScreen = false
        }
    }
    
    private func onSuccess() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showPinScreen = false
        }
    }
}
