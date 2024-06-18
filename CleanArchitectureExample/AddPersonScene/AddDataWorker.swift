//
//  AddDataWorker.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import Foundation
import CoreData
import UIKit
import Alamofire

protocol AddDataWorkerProtocol {
    func storeData(model: PersonModel, completionHandler: (Bool, String) -> ())
    func getResponse()
}

class AddDataWorker: AddDataWorkerProtocol {
    func storeData(model: PersonModel, completionHandler: (Bool,String) -> ()) {
        let managedContext = PersistentStorage.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "email = %@", model.email)
        fetchRequest.predicate = predicate
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count > 0 {
                completionHandler(false, "Email already exists")
                return
            }
        } catch {
            completionHandler(false,"Error while getting data")
            print("Error while fetching data")
        }
        
        let personEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let person = NSManagedObject(entity: personEntity, insertInto: managedContext)
        person.setValue(model.firstName, forKey: "firstName")
        person.setValue(model.lastName, forKey: "lastName")
        person.setValue(model.email, forKey: "email")
        do {
            try managedContext.save()
            completionHandler(true, "Data added successfully")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            completionHandler(false,"Error while saving data")
        }
        print("Store data completed")
    }
    
    func getResponse() {
        AF.request("https://httpbin.org/get").response { response in
            print("##### \(response)")
        }
        
        AF.request("https://httpbin.org/get").responseData { response in
            print("##### Data \(response)")
        }
        
        AF.request("https://httpbin.org/get").responseString { response in
            print("##### String \(response)")
        }
        
        struct HTTPBinResponse: Decodable { let url: String }
        AF.request("https://httpbin.org/get").responseDecodable(of: HTTPBinResponse.self) { response in
            print("##### \(response)")
        }
    }
}
