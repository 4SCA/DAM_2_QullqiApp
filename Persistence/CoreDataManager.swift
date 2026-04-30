import CoreData

final class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name:"QullqiApp")
        
        container.loadPersistentStores {_, error in
            if let error {
                fatalError("Error al cargar Core Data: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else {return}
        
        do{
            try context.save()
        } catch {
            print("Error al guardar contexto: \(error.localizedDescription)")
        }
    }
}
