//
//  UpdateDataInteractor.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import Foundation

protocol UpdateDataInteractorProtocol {
    func requestUpdateData(oldEmail: String,newModel:PersonModel)
}

class UpdateDataInteractor {
    var presenter: UpdateDataPresenterProtocol?
    var worker: UpdateDataWorkerProtocol?
}

extension UpdateDataInteractor: UpdateDataInteractorProtocol {
    func requestUpdateData(oldEmail: String, newModel: PersonModel) {
        worker?.updateData(email: oldEmail, newModel: newModel) { result in
            switch result {
            case .success(let data):
                if data {
                    presenter?.showDetailScreen()
                } else {
                    presenter?.showEmailExistsAlert()
                }
            case .failure(let error):
                presenter?.showFailureAlert()
                print(error.localizedDescription)
            }
        }
    }
}
