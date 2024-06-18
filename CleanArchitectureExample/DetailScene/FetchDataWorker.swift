//
//  File.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 14/06/23.
//

import Foundation
import CoreData
import UIKit

protocol FetchDataWorkerProtocol {
    func fetchData() -> [PersonModel]
}

class FetchDataWorker {
    
}

extension FetchDataWorker: FetchDataWorkerProtocol {
    func fetchData() -> [PersonModel] {
        // Fetch data from core data
        var modelArray: [PersonModel] = []
        let managedContext = PersistentStorage.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let firstName = data.value(forKey: "firstName") as! String
                let lastName = data.value(forKey: "lastName") as! String
                let email = data.value(forKey: "email") as! String
                modelArray.append(PersonModel(firstName: firstName, lastName: lastName, email: email))
            }
        } catch {
            print("Failed to fetch data")
        }
        return modelArray
    }
    
    
}
