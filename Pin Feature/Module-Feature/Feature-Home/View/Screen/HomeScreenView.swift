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
    
    enum DuoPose {
        case noHinge
        case closed
        case partiallyOpen
        case fullyOpen
    }
    
    private let isDuo = UIDevice.current.name.localizedCaseInsensitiveContains("iPhone Duo")
    
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
                
                showPinTapArea
                
                pinLayer
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
        Color.clear
            .background {
                Image("dummy-homeScreenView-Image")
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
            }
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

private struct HingeTracker: ViewModifier {
    @Binding var pose: HomeScreenView.DuoPose
    
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

#Preview {
    HomeScreenView()
}
