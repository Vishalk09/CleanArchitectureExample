//
//  UpdateDataViewController.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 15/06/23.
//

import UIKit

protocol UpdateDataViewControllerProtocol {
    func backToDetailsScreen()
    func showEmailAlreadyExistsAlert()
    func showUpdateFailureAlert()
}

class UpdateDataViewController: UIViewController {
    
    // Storyboard outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var interactor: UpdateDataInteractorProtocol?
    var router: UpdateDataRouterProtocol?
    var model: PersonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        setUp()
    }
    @IBAction func updateData(_ sender: Any) {
        guard let oldEmail = model?.email else { return }
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            return
        }
        let newModel = PersonModel(firstName: firstName, lastName: lastName, email: email)
        interactor?.requestUpdateData(oldEmail: oldEmail, newModel: newModel)
    }
    
    private func setUp() {
        let viewController = self;
        let worker = UpdateDataWorker()
        let interactor = UpdateDataInteractor()
        let presenter = UpdateDataPresenter()
        let router = UpdateDataRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        
        guard let personModel = model else { return }
        firstNameTextField.text = personModel.firstName
        lastNameTextField.text = personModel.lastName
        emailTextField.text = personModel.email
    }
}

extension UpdateDataViewController: UpdateDataViewControllerProtocol {
    func backToDetailsScreen() {
        router?.showDetailScreen()
    }
    
    func showEmailAlreadyExistsAlert() {
        router?.showEmailAlreadyExistsAlert()
    }
    
    func showUpdateFailureAlert() {
        router?.showUpdateFailureAlert()
    }
}
