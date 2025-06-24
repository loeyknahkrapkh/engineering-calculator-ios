//
//  ContentView.swift
//  EngineeringCalculator
//
//  Created by @loeyknahkrapkh on 6/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appContainer = AppContainer()
    
    var body: some View {
        CalculatorView(
            viewModel: appContainer.calculatorViewModel,
            appContainer: appContainer
        )
        .preferredColorScheme(.light) // 기본 라이트 모드
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            appContainer.applicationDidEnterBackground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            appContainer.applicationWillEnterForeground()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            appContainer.applicationWillResignActive()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            appContainer.applicationDidBecomeActive()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            appContainer.applicationWillTerminate()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            appContainer.handleMemoryWarning()
        }
        .onReceive(NotificationCenter.default.publisher(for: .NSProcessInfoPowerStateDidChange)) { _ in
            appContainer.handleLowPowerMode()
        }
        .onReceive(NotificationCenter.default.publisher(for: .calculatorStateChanged)) { _ in
            appContainer.markAsChanged()
        }
    }
}

#Preview {
    ContentView()
}
