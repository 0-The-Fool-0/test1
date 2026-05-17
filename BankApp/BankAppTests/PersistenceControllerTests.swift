//
//  PersistenceControllerTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct PersistenceControllerTests {
    @Test func inMemoryStoreLoadsSuccessfully() {
        #expect(TestPersistence.controller.container.persistentStoreCoordinator.persistentStores.isEmpty == false)
    }

    @Test func seededStoreContainsDemoUser() {
        TestPersistence.makeSeededSession()
        let count = (try? TestPersistence.viewContext.count(for: User.fetchRequest())) ?? 0
        #expect(count >= 1)
    }
}
