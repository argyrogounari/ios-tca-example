//
//  Counter.swift
//  TCAExample (iOS)
//
//  Created by Argyro Gounari on 30/01/2023.
//

import Foundation
import Combine
import ComposableArchitecture

struct CounterState: Equatable {
    var value = 0
}

enum CounterAction: Equatable {
    case onAppear
    case incrementTapped
    case updateStateValue(Int)
}

struct CounterEnvironment {
    let value: CurrentValueSubject<Int, Never>
}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, environment in
    switch action {
    case .incrementTapped:
        state.value = state.value + 1
        environment.value.value = state.value
        return .none
    case let .updateStateValue(newValue):
        state.value = newValue
        return .none
    case .onAppear:
        return environment.value.map(CounterAction.updateStateValue).eraseToEffect()
    }
}

