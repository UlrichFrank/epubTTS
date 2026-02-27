import CoreData
import Foundation

/// Core Data Stack for managing persistent data in Release 2.0
public class CoreDataStack {
    /// Singleton instance
    static let shared = CoreDataStack()
    
    /// Main persistent container
    let persistentContainer: NSPersistentContainer
    
    /// Main thread managed object context
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    /// Background context for heavy operations
    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        // Load the Core Data model from the bundle
        let bundle = Bundle.main
        guard let modelURL = bundle.url(forResource: "CoreDataModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }
        
        persistentContainer = NSPersistentContainer(name: "CoreDataModel", managedObjectModel: model)
        
        // Load persistent stores
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data stack initialization failed: \(error), \(error.userInfo)")
            }
        }
        
        // Configure for concurrent access
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    /// Save changes to the view context
    func saveViewContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    /// Perform a background operation with automatic save
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T, completion: @escaping (Result<T, Error>) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let result = try block(context)
                if context.hasChanges {
                    try context.save()
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Delete all data (for testing only)
    func deleteAllData() throws {
        let context = viewContext
        for entity in persistentContainer.managedObjectModel.entities {
            guard let entityName = entity.name else { continue }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)
        }
        try saveViewContext()
    }
}
