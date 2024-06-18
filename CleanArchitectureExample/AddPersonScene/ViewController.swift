//
//  ViewController.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import UIKit
import FirebaseAnalytics

protocol ViewControllerProtocol {
    func showFailureAlert(message: String)
    func showSuccessAlert()
}

class ViewController: UIViewController {
    
    // Storyboard outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // varibales
    var router: AddDataRouterProtocol?
    var interactor: AddDataInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemCyan
        self.navigationItem.title = "Add Data"
        
        // Configure
        setUp()
        interactor?.getResponse()
        
    }
    @IBAction func doSomeThing(_ sender: Any) {
        print("Did tap submit")
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            router?.showEmptyFieldAlert(message: "First name field is empty")
            Analytics.logEvent("empty_field", parameters: [
                "event_category":"button_click",
                "event_label":"empty_field"])
            Analytics.setUserProperty("failure_alert", forName: "alert_type")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            router?.showEmptyFieldAlert(message: "Last name field is empty")
            Analytics.logEvent("empty_field", parameters: [
                "event_category":"button_click",
                "event_label":"empty_field"])
            Analytics.setUserProperty("failure_alert", forName: "alert_type")
            return
        }
        guard let email =  emailTextField.text, !email.isEmpty else {
            router?.showEmptyFieldAlert(message: "Email field is empty")
            Analytics.logEvent("empty_field", parameters: [
                "event_category":"button_click",
                "event_label":"empty_field"])
            Analytics.setUserProperty("failure_alert", forName: "alert_type")
            return
        }
        interactor?.addDataToCoreData(firstName: firstName, lastName: lastName, email: email)
    }
    @IBAction func showData(_ sender: Any) {
        Analytics.logEvent(AnalyticsEventViewItemList, parameters: [AnalyticsParameterItemID: "my_item_id"])
        router?.showNextScreen()
    }
    
// configures viewController for clean architecture
    private func setUp() {
        let viewController =  self
        let router = AddDataRouter()
        let interactor = AddDataInteractor()
        let presenter = AddDataPresenter()
        let worker = AddDataWorker()
        viewController.router = router
        viewController.interactor = interactor
        router.vc = viewController
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.worker = worker
    }
}

// Extension to implement Viewcontroller protocol
extension ViewController: ViewControllerProtocol {
    // Success dialog when data is added successfully
    func showSuccessAlert() {
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        router?.showAddDataSuccessAlert()
        Analytics.logEvent("add_data_success", parameters: ["event_category":"button_click",
                                                            "event_label": "add_data_success"])
        Analytics.setUserProperty("success_alert", forName: "alert_type")
    }
    
    func showFailureAlert(message: String) {
        router?.showAddDataFailureAlert(message: message)
        Analytics.logEvent("add_data_failure", parameters: ["event_category":"button_click",
                                                            "event_label": "add_data_failure"])
        Analytics.setUserProperty("failure_alert", forName: "alert_type")

    }
}

