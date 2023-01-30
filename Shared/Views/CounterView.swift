//
//  CounterView.swift
//  TCAExample (iOS)
//
//  Created by Argyro Gounari on 30/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store.scope(
            state: \.counter,
            action: AppAction.counter
        )) { viewStore in
            VStack {
                Text("Current value \(viewStore.state.value)")
                Button(
                    "+ Increment",
                    action: {
                        viewStore.send(.incrementTapped)
                    }
                )
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
