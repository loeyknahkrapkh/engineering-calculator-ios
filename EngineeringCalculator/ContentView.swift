//
//  ContentView.swift
//  EngineeringCalculator
//
//  Created by @loeyknahkrapkh on 6/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CalculatorView(
            viewModel: CalculatorViewModel(
                calculatorEngine: ScientificCalculatorEngine(),
                settingsStorage: UserDefaultsSettingsStorage(),
                historyStorage: InMemoryHistoryStorage()
            )
        )
        .preferredColorScheme(.light) // 기본 라이트 모드
    }
}

#Preview {
    ContentView()
}
