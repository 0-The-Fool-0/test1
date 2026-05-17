//
//  ViewTestSupport.swift
//  BankAppTests
//

import CoreData
import SwiftUI
import UIKit
@testable import BankApp

@MainActor
enum ViewTestSupport {
    static func host<V: View>(_ view: V) -> UIHostingController<V> {
        let controller = UIHostingController(rootView: view)
        controller.loadViewIfNeeded()
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()
        return controller
    }

    @MainActor
    static func seededDependencies() -> (AppDependencies, SessionStore, UserSession) {
        let session = TestPersistence.makeSeededSession()
        let dependencies = AppDependencies(persistence: TestPersistence.controller)
        return (dependencies, SessionStore(), session)
    }
}
