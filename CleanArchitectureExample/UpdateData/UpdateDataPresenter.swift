//
//  UpdateDataPresenter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import Foundation

protocol UpdateDataPresenterProtocol {
    func showDetailScreen()
    func showEmailExistsAlert()
    func showFailureAlert()
}

class UpdateDataPresenter {
    var viewController: UpdateDataViewControllerProtocol?
}

extension UpdateDataPresenter: UpdateDataPresenterProtocol{
    func showDetailScreen() {
        viewController?.backToDetailsScreen()
    }
    
    func showEmailExistsAlert() {
        viewController?.showEmailAlreadyExistsAlert()
    }
    
    func showFailureAlert() {
        viewController?.showUpdateFailureAlert()
    }
}
