//
//  HomeScreenView.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var navigateToPinScren: Bool = false
    
    var body: some View {
        Container
    }
}

extension HomeScreenView {
    private var Container: some View {
        NavigationStack {
            VStack {
                Button("Unlock") {
                    navigateToPinScren = true
                }
                .font(.nunito(15, weight: .regular))
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(
                        cornerRadius: 15, style: .continuous
                    )
                    .fill(Color.cyan)
                )
            }
            .navigationDestination(isPresented: $navigateToPinScren) {
                PinScreenView()
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
