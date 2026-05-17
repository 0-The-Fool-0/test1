//
//  PersistenceController.swift
//  BankApp
//

import CoreData

/// Core Data stack backed by SQLite (`NSSQLiteStoreType`).
struct PersistenceController {
    static let shared = PersistenceController()

    /// Single in-memory stack for XCTest host and `-UITesting` launches.
    static let testing = PersistenceController(inMemory: true)

    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        return controller
    }()

    static var isRunningUnitTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BankApp")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let description = container.persistentStoreDescriptions.first
            description?.type = NSSQLiteStoreType
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
