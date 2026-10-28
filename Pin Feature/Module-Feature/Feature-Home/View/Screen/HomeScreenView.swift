//
//  HomeScreenView.swift
//  Pin Feature
//
//  Created by Panha on 14/10/26.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var viewModel = HomeScreenViewModel()
        
    private let isDuo = DeviceInfo.isDuo
    
    var body: some View {
        container
            .modifier(HingeTracker(pose: $viewModel.pose))
    }
}

extension HomeScreenView {
    private var container: some View {
        NavigationStack {
            ZStack {
                Color(hex: "093558")
                    .ignoresSafeArea()
                 
                background
                
                if viewModel.isShowingPinScreen {
                    Group {
                        if isDuo {
                            NavigationStack {
                                PinScreenView(onDismiss: viewModel.hidePin, onSuccess: viewModel.onSuccess)
                            }
                        } else {
                            PinScreenView(onDismiss: viewModel.hidePin, onSuccess: viewModel.onSuccess)
                        }
                    }
                    .opacity(viewModel.pinOpacity)
                    .zIndex(1)
                }
            }
            .toolbar {
                if !viewModel.isShowingPinScreen {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: viewModel.showPin) {
                            Image(systemName: "lock.open")
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
        if viewModel.isUnfolded {
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
