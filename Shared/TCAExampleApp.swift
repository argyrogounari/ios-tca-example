//
//  TCAExampleApp.swift
//  Shared
//
//  Created by Argyro Gounari on 30/01/2023.
//

import SwiftUI
import Combine
import ComposableArchitecture

@main
struct TCAExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WelcomeView(
                    store: Store(
                        initialState: AppState(
                            welcome: WelcomeState(),
                            counter: CounterState()
                        ),
                        reducer: appReducer,
                        environment: AppEnvironment(
                            value: CurrentValueSubject<Int, Never>(0)
                        )
                    )
                )
            }
        }
    }
}
