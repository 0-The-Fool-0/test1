//
//  LoginViewModelTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

@MainActor
struct LoginViewModelTests {
    @Test func signInWithEmptyFieldsSetsError() {
        TestPersistence.makeSeededSession()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: TestPersistence.viewContext),
            session: session
        )

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInWithInvalidCredentialsSetsError() {
        TestPersistence.makeSeededSession()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: TestPersistence.viewContext),
            session: session
        )
        viewModel.login = "elena.kuznetsova"
        viewModel.password = "wrong"

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInTrimsLoginWhitespace() {
        TestPersistence.makeSeededSession()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: TestPersistence.viewContext),
            session: session
        )
        viewModel.login = "  elena.kuznetsova  "
        viewModel.password = "demo1234"

        viewModel.signIn()

        #expect(session.isAuthenticated)
    }

    @Test func faceIDTappedShowsAlert() {
        let viewModel = LoginViewModel(
            authService: AuthService(context: TestPersistence.viewContext),
            session: SessionStore()
        )

        viewModel.faceIDTapped()

        #expect(viewModel.showFaceIDAlert)
    }

    @Test func signInWithValidCredentialsAuthenticatesUser() {
        TestPersistence.makeSeededSession()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: TestPersistence.viewContext),
            session: session
        )
        viewModel.login = "elena.kuznetsova"
        viewModel.password = "demo1234"

        viewModel.signIn()

        #expect(viewModel.errorMessage == nil)
        #expect(session.isAuthenticated)
        #expect(session.currentUser?.displayName == "Елена")
    }
}
