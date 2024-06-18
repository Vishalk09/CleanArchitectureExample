//
//  AddDataInteractor.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import Foundation

protocol AddDataInteractorProtocol{
    func addDataToCoreData(firstName: String, lastName: String ,email: String)
    func getResponse()
}

class AddDataInteractor {
    var presenter: AddDataPresenterProtocol?
    var worker: AddDataWorkerProtocol?
}

extension AddDataInteractor: AddDataInteractorProtocol {
    func addDataToCoreData(firstName: String, lastName: String, email: String) {
        //add code
        let person = PersonModel(firstName: firstName, lastName: lastName, email: email)
        // TODO: create completion handler logic for failure and success
        worker?.storeData(model: person) { flag, message in
            if flag {
                presenter?.addDataSuccess()
                print("Add data to core data")
            } else {
                presenter?.addDataFailure(message: message)
            }
        }
    }
    
    func getResponse() {
        worker?.getResponse()
    }
}
