//
//  AddDataPresenter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import Foundation
import UIKit

protocol AddDataPresenterProtocol {
    func addDataSuccess()
    func addDataFailure(message: String)
}

class AddDataPresenter {
    var viewController: ViewControllerProtocol?
}
extension AddDataPresenter:AddDataPresenterProtocol {
    func addDataSuccess() {
        viewController?.showSuccessAlert()
    }
    func addDataFailure(message: String) {
        viewController?.showFailureAlert(message: message)
    }
}
