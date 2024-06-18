//
//  AddDataRouter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import UIKit

protocol AddDataRouterProtocol {
    func showNextScreen()
    func showEmptyFieldAlert(message: String)
    func showAddDataSuccessAlert()
    func showAddDataFailureAlert(message: String)
}

class AddDataRouter {
    weak var vc: UIViewController?
    
    private func createAlertController(title: String, message: String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        return alertController
    }
}

extension AddDataRouter: AddDataRouterProtocol {
    
    func showNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController")
        vc?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showEmptyFieldAlert(message: String) {
        let alertController = createAlertController(title: "Error!", message: message)
        vc?.present(alertController, animated: true)
    }
    
    func showAddDataSuccessAlert() {
        let alertController = createAlertController(title: "Success!", message: "Data added successfully")
        vc?.present(alertController, animated: true)
    }
    
    func showAddDataFailureAlert(message: String) {
        let alertController = createAlertController(title: "Failure!", message: message)
        vc?.present(alertController, animated: true)
    }
}
