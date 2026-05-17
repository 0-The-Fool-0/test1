//
//  ExchangeRateServiceTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct ExchangeRateServiceTests {
    @Test func fetchRatesReturnsEmptyWhenDatabaseIsEmpty() {
        TestPersistence.reset()
        let service = ExchangeRateService(context: TestPersistence.viewContext)

        #expect(service.fetchRates().isEmpty)
    }

    @Test func fetchRatesReturnsSeededCurrencies() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = ExchangeRateService(context: persistence.container.viewContext)

        let rates = service.fetchRates()

        #expect(rates.count == 2)
        #expect(rates.map(\.currencyCode).sorted() == ["EUR", "USD"])
        #expect(rates.first { $0.currencyCode == "USD" }?.buyRate == 92.40)
    }
}
