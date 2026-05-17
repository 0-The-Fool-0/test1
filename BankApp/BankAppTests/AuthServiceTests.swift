//
//  AuthServiceTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct AuthServiceTests {
    @Test func validateReturnsSessionForDemoUser() {
        let expected = TestPersistence.makeSeededSession()
        let auth = AuthService(context: TestPersistence.viewContext)

        let result = auth.validate(login: "elena.kuznetsova", password: "demo1234")

        #expect(result == expected)
    }

    @Test func validateReturnsNilForUnknownLogin() {
        TestPersistence.makeSeededSession()
        let auth = AuthService(context: TestPersistence.viewContext)

        #expect(auth.validate(login: "nobody", password: "demo1234") == nil)
    }

    @Test func validateReturnsNilForWrongPassword() {
        TestPersistence.makeSeededSession()
        let auth = AuthService(context: TestPersistence.viewContext)

        #expect(auth.validate(login: "elena.kuznetsova", password: "wrong") == nil)
    }

}
