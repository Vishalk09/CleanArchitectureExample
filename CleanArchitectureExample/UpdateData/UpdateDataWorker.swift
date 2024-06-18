//
//  UpdateDataWorker.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import Foundation
import CoreData
import UIKit

protocol UpdateDataWorkerProtocol {
    func updateData(email: String, newModel: PersonModel, completionHandler: (Result<Bool,UpdateDataWorker.UpdateDataError>) -> Void)
}

class UpdateDataWorker {
    enum UpdateDataError: Error {
        case serverError(String)
        case updateError(String)
    }
}

extension UpdateDataWorker: UpdateDataWorkerProtocol {
    func updateData(email: String, newModel: PersonModel, completionHandler: (Result<Bool, UpdateDataError>) -> Void) {
        let managedContext = PersistentStorage.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var predicate = NSPredicate(format: "email = %@", newModel.email)
        fetchRequest.predicate = predicate
        
        if email != newModel.email{
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    completionHandler(.success(false))
                    return
                }
            } catch {
                completionHandler(.failure(.serverError("Server error")))
            }
        }
        
        predicate = NSPredicate(format: "email = %@", email)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let data = result[0] as! NSManagedObject
            data.setValue(newModel.firstName, forKey: "firstName")
            data.setValue(newModel.lastName, forKey: "lastName")
            data.setValue(newModel.email, forKey: "email")
            try managedContext.save()
            completionHandler(.success(true))
        } catch {
            completionHandler(.failure(.updateError("Failed to update data")))
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
