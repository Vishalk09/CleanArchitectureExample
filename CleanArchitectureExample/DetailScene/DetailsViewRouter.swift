//
//  DetailsViewRouter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 14/06/23.
//

import Foundation
import UIKit

protocol DetailsViewRouterProtocol {
    func showExpandedView()
    func showDataLoadFailureAlert()
    func showDeleteDataSuccess()
    func showDeleteDataFailure()
    func showUpdateDataScreen(model: PersonModel)
}

class DetailsViewRouter {
    weak var viewController: UIViewController?
    
    private func showAlertController(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        viewController?.present(alertController, animated: true)
    }
    
}

extension DetailsViewRouter: DetailsViewRouterProtocol {
    func showExpandedView() {
        // present expanded view for table view cells
    }
    
    func showDataLoadFailureAlert() {
        showAlertController(title: "Error!", message: "Error loading data")
    }
    
    func showDeleteDataSuccess() {
        showAlertController(title: "Success", message: "Deleted data successfully")
    }
    
    func showDeleteDataFailure() {
        showAlertController(title: "Failure!", message: "Failed to delete data")
    }
    
    func showUpdateDataScreen(model: PersonModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateDataViewController = storyboard.instantiateViewController(withIdentifier: "UpdateDataViewController") as! UpdateDataViewController
        updateDataViewController.model = model
        viewController?.navigationController?.pushViewController(updateDataViewController, animated: true)
    }
}
