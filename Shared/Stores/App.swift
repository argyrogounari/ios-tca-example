//
//  App.swift
//  TCAExample (iOS)
//
//  Created by Argyro Gounari on 30/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture

enum APIError: Error, Equatable {
    case runtimeError(String)
}

struct AppState : Equatable {
    var welcome: WelcomeState
    var counter: CounterState
}

enum AppAction: Equatable  {
    case welcome(WelcomeAction)
    case counter(CounterAction)
}

struct AppEnvironment {
    let value: CurrentValueSubject<Int, Never>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    welcomeReducer.pullback(
        state: \.welcome,
        action: /AppAction.welcome,
        environment: { env in
            WelcomeEnvironment(
            mainQueue: .main,
            fetchPreviousValueAPICall: { Effect<Int,APIError>(value: 5) },
            value: env.value
        )
    }),
    counterReducer.pullback(
        state: \.counter,
        action: /AppAction.counter,
        environment: { env in CounterEnvironment(
            value: env.value
        )}
    )
)

