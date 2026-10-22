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
    
    var body: some View {
        if #available(anyAppleOS 27.1, *) {
            Container
                .onHingeChange { _, context in
                    guard let hinge = context.hinge else {
                        pose = .noHinge
                        return
                    }
                    
                    switch hinge.status {
                    case .closed:           pose = .closed
                    case .partiallyOpen:    pose = .partiallyOpen
                    case .fullyOpen:        pose = .fullyOpen
                    default:                break
                    }
                }
        } else {
            Container
        }
    }
}

extension HomeScreenView {
    private var Container: some View {
        NavigationStack {
            ZStack {
                Color(hex: "093558")
                    .ignoresSafeArea()
                
                if isDuo, #available(anyAppleOS 27.1, *) {
                    if pose == .partiallyOpen || pose == .fullyOpen {
                        ArrangementView {
                            Color(.clear)
                                .background {
                                    Image("dummy-homeScreenView-Image")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .ignoresSafeArea()
                        } secondary: {
                            Color(.clear)
                                .background {
                                    Image("dummy-homeScreenView-Image")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .ignoresSafeArea()
                        }
                        .arrangementViewStyle(.split.axes(.horizontal))
                    } else {
                        Color(.clear)
                            .background {
                                Image("dummy-homeScreenView-Image")
                                    .resizable()
                                    .scaledToFit()
                            }
                            .ignoresSafeArea()
                    }
                } else {
                    Color(.clear)
                        .background {
                            Image("dummy-homeScreenView-Image")
                                .resizable()
                                .scaledToFill()
                        }
                        .ignoresSafeArea()
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showPinScreen = true
                    }
                } label: {
                    Color.clear
                }
                .contentShape(Rectangle())
                .ignoresSafeArea()
                
                if showPinScreen {
                    PinScreenView(
                        onDismiss: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showPinScreen = false
                            }
                        },
                        onSuccess: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showPinScreen = false
                            }
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    }
}
