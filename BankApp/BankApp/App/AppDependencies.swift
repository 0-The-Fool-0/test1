//
//  AppDependencies.swift
//  BankApp
//

import CoreData
import SwiftUI
import Combine

@MainActor
final class AppDependencies: ObservableObject {
    let persistence: PersistenceController
    let authService: AuthService
    let accountService: AccountService
    let exchangeRateService: ExchangeRateService
    let branchService: BranchService

    var viewContext: NSManagedObjectContext {
        persistence.container.viewContext
    }

    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITesting")
    }

    init(persistence: PersistenceController? = nil) {
        let resolvedPersistence = persistence ?? (Self.isUITesting ? PersistenceController(inMemory: true) : .shared)
        self.persistence = resolvedPersistence
        let context = resolvedPersistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        authService = AuthService(context: context)
        accountService = AccountService(context: context)
        exchangeRateService = ExchangeRateService(context: context)
        branchService = BranchService(context: context)
    }
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies? = nil
}

extension EnvironmentValues {
    var appDependencies: AppDependencies? {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
