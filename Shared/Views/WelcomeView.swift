//
//  WelcomeView.swift
//  TCAExample (iOS)
//
//  Created by Argyro Gounari on 30/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture
import SwiftUI

struct WelcomeView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store.scope(
            state: \.welcome,
            action: AppAction.welcome
        )) { viewStore in
            VStack {
                NavigationLink(destination: CounterView(store: store), isActive: viewStore.binding(
                    get: { $0.isShowingDetailView },
                    send: .dismissTapped
                )) { EmptyView() }
                
                Text("The counter is at \(viewStore.value)").padding()
                
                Button(
                    "Click for counter ->",
                    action: {
                        viewStore.send(.welcomeTapped)
                    }
                )
            }.onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
