//
//  BranchServiceTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct BranchServiceTests {
    @Test func fetchAllBranchesReturnsEmptyWithoutSeed() {
        TestPersistence.reset()
        let service = BranchService(context: TestPersistence.viewContext)

        #expect(service.fetchAllBranches().isEmpty)
    }

    @Test func fetchAllBranchesReturnsSeededOffices() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = BranchService(context: persistence.container.viewContext)

        let branches = service.fetchAllBranches()

        #expect(branches.count == 4)
        #expect(branches.allSatisfy { !$0.address.isEmpty })
    }
}
