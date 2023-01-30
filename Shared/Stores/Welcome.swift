//
//  Welcome.swift
//  TCAExample (iOS)
//
//  Created by Argyro Gounari on 30/01/2023.
//

import Foundation
import ComposableArchitecture
import Combine

struct WelcomeState: Equatable {
    var isViewFirstAppear = true
    var isShowingDetailView = false
    var value = 0
}

enum WelcomeAction: Equatable {
    case onAppear
    case fetchPreviousValue
    case fetchPreviousValueResponse(Result<Int, APIError>)
    case updateStateValue(Int)
    case updateEnvValue(Int)
    case welcomeTapped
    case dismissTapped
}

struct WelcomeEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let fetchPreviousValueAPICall: () -> Effect<Int, APIError>
    let value: CurrentValueSubject<Int, Never>
}

let welcomeReducer = Reducer<WelcomeState, WelcomeAction, WelcomeEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        if state.isViewFirstAppear {
            state.isViewFirstAppear = false
            return Effect.concatenate([
                Effect(value: .fetchPreviousValue),
                environment.value.map(WelcomeAction.updateEnvValue).eraseToEffect()
            ])
        }
        return environment.value.map(WelcomeAction.updateEnvValue).eraseToEffect()
    case .fetchPreviousValue:
        return environment.fetchPreviousValueAPICall()
            .receive(on: environment.mainQueue).catchToEffect().map(WelcomeAction.fetchPreviousValueResponse)
    case let .fetchPreviousValueResponse(.success(newValue)):
        state.value = newValue
        return Effect(value: .updateStateValue(newValue))
    case .fetchPreviousValueResponse(.failure):
        return .none
    case let .updateStateValue(newValue):
        environment.value.value = newValue
        return .none
    case let .updateEnvValue(newValue):
        state.value = newValue
        return .none
    case .welcomeTapped:
        state.isShowingDetailView = true
        return .none
    case .dismissTapped:
        state.isShowingDetailView = false
        return .none
    }
}

