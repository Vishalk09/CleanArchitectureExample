//
//  DeleteDataWorker.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import Foundation
import CoreData
import UIKit

protocol DeleteDataWorkerProtocol {
    func deleteData(email: String, completionHandler: (Bool) -> Void)
}

class DeleteDataWorker: DeleteDataWorkerProtocol {
    func deleteData(email: String, completionHandler: (Bool) -> Void) {
        let managedContext = PersistentStorage.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
            try managedContext.save()
            completionHandler(true)
        } catch {
            completionHandler(false)
            print("Failed to fetch data")
        }
    }
    
    
    //    TODO: Move to suitable file
//        func deleteAllData() {
//            let managedContext = PersistentStorage.shared.context
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//            do {
//                let result = try managedContext?.fetch(fetchRequest)
//                for data in result as! [NSManagedObject] {
//                    managedContext?.delete(data)
//                }
//                try managedContext?.save()
//            } catch let error as NSError {
//                print("Error while deleting record \(error), \(error.userInfo)")
//            }
//        }
        
}

