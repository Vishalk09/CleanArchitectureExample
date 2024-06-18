//
//  DetailsViewPresenter.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 14/06/23.
//

import Foundation

protocol DetailsViewPresenterProtocol {
    func createViewModelForDetailView(response: [PersonModel]?)
    func showDeleteDataFailure()
    func showDeleteDataSuccess()
}

class DetailsViewPresenter {
    var viewController: DetailsViewControllerProtocol?
}

extension DetailsViewPresenter: DetailsViewPresenterProtocol {
    func createViewModelForDetailView(response: [PersonModel]?) {
        // add logic to pass data to view
        if let data = response {
            viewController?.loadDataToTableView(data: data)
        } else {
            viewController?.showLoadDataFailure()
        }
    }
    
    func showDeleteDataSuccess() {
        viewController?.showDeleteDataSuccess()
    }
    
    func showDeleteDataFailure() {
        viewController?.showLoadDataFailure()
    }
}
