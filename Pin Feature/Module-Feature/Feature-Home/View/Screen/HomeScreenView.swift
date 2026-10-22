//
//  HomeScreenView.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var showPinScreen: Bool = true
    
    var body: some View {
        Container
    }
}

extension HomeScreenView {
    private var Container: some View {
        ZStack {
            Color(.white.withAlphaComponent(0))
                .background {
                    Image("dummy-homeScreenView-Image")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                .ignoresSafeArea()
            
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

#Preview {
    HomeScreenView()
}
