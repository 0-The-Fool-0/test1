//
//  TestPersistence.swift
//  BankAppTests
//

import CoreData
@testable import BankApp

/// Single in-memory Core Data stack for the unit-test process.
/// Avoids "Multiple NSEntityDescriptions" crashes when tests run in parallel in one host.
enum TestPersistence {
    static let controller = PersistenceController.testing

    static var viewContext: NSManagedObjectContext {
        controller.container.viewContext
    }

    static func reset() {
        viewContext.performAndWait {
            let entityNames = ["Account", "User", "Branch", "ExchangeRate"]
            for name in entityNames {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                request.includesPropertyValues = false
                request.resultType = .managedObjectResultType
                if let objects = try? viewContext.fetch(request) as? [NSManagedObject] {
                    objects.forEach { viewContext.delete($0) }
                }
            }
            if viewContext.hasChanges {
                try? viewContext.save()
            }
        }
    }

    static func makeSeededSession() -> UserSession {
        reset()
        DataSeedService(context: viewContext).seedIfNeeded()
        guard let session = AuthService(context: viewContext)
            .validate(login: "elena.kuznetsova", password: "demo1234") else {
            fatalError("Seed user must be available for tests")
        }
        return session
    }
}
