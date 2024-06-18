//
//  UpdateDataRouter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import Foundation
import UIKit

protocol UpdateDataRouterProtocol {
    func showDetailScreen()
    func showEmailAlreadyExistsAlert()
    func showUpdateFailureAlert()
}

class UpdateDataRouter {
    weak var viewController: UIViewController?
    private func createAlertController(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        viewController?.present(alertController, animated: true)
    }
}

extension UpdateDataRouter: UpdateDataRouterProtocol {
    func showDetailScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showEmailAlreadyExistsAlert() {
        createAlertController(title: "Error", message: "Email already exists, please try other email")
    }
    
    func showUpdateFailureAlert() {
        createAlertController(title: "Failure!", message: "Failed to update the data, please try again!")
    }
}
