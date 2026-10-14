//
//  HomeScreenView.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var showPinScreen: Bool = false
    
    var body: some View {
        Container
    }
}

extension HomeScreenView {
    private var Container: some View {
        ZStack {
            Color(hex: "162634")
                .ignoresSafeArea()
            
            VStack {
                Button("Unlock") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showPinScreen = true
                    }
                }
                .font(.nunito(15, weight: .regular))
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(
                        cornerRadius: 24, style: .continuous
                    )
                    .fill(Color.cyan.opacity(0.75))
                )
            }
            
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
