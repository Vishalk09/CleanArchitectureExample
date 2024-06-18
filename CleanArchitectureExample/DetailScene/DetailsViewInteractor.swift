//
//  DetailsViewInteractor.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 14/06/23.
//

import Foundation

protocol DetailsViewInteractorProtocol {
    func getDataToLoad()
    func deleteSelectedData(email: String)
}

class DetailsViewInteractor {
    var fetchWorker: FetchDataWorkerProtocol?
    var deleteWorker: DeleteDataWorkerProtocol?
    var presenter: DetailsViewPresenterProtocol?
    
}

extension DetailsViewInteractor: DetailsViewInteractorProtocol {
    func getDataToLoad() {
        // Get data from worker
        let response = fetchWorker?.fetchData()
        // Pass response to presenter
        presenter?.createViewModelForDetailView(response: response)
    }
    func deleteSelectedData(email: String) {
        deleteWorker?.deleteData(email: email) { flag in
            if flag {
                presenter?.showDeleteDataSuccess()
            } else {
                presenter?.showDeleteDataFailure()
            }
        }
    }
}
