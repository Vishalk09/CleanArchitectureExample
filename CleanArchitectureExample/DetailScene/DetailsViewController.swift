//
//  DetailsViewController.swift
//  CleanArchitectureExample
//
//  Created by Vishal Khokad on 13/06/23.
//

import UIKit
import FirebaseAnalytics

protocol DetailsViewControllerProtocol{
    func loadDataToTableView(data: [PersonModel])
    func showLoadDataFailure()
    func showDeleteDataFailure()
    func showDeleteDataSuccess()
}

class DetailsViewController: UIViewController {
    @IBOutlet weak var personTableView: UITableView!
    // TODO: Remove and update with suitable logic
    private var modelArray: [PersonModel] = []
    var interactor: DetailsViewInteractorProtocol?
    var router: DetailsViewRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up views before loading
        setUp()
        navigationItem.title = "User Data"

        personTableView.delegate = self
        personTableView.dataSource = self
        personTableView.register(PersonTableViewCell.nib, forCellReuseIdentifier: PersonTableViewCell.identifier)
        
        // fetch data
        interactor?.getDataToLoad()
        personTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // fetch data
        interactor?.getDataToLoad()
        personTableView.reloadData()
    }
    
    private func setUp() {
        let viewController = self
        let presenter = DetailsViewPresenter()
        let interactor = DetailsViewInteractor()
        let fetchWorker = FetchDataWorker()
        let deleteWorker = DeleteDataWorker()
        let router = DetailsViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        presenter.viewController = viewController
        interactor.fetchWorker = fetchWorker
        interactor.deleteWorker = deleteWorker
        interactor.presenter = presenter
        router.viewController = viewController
    }
    
    private func shouldShowDeleteAlert() -> Bool {
        let alertController = UIAlertController(title: "Delete?", message: "Do want to delete this data?", preferredStyle: .alert)
        var flag = false
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { _ in
            flag = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        return flag
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // update later
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
        cell.nameLabel.text = "Name: \(modelArray[indexPath.row].firstName) \(modelArray[indexPath.row].lastName)"
        cell.emailLabel.text = "Email: \(modelArray[indexPath.row].email)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row tapped");
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {[weak self] _,_,_ in
//            guard let shouldDelete = self?.shouldShowDeleteAlert() else {   return }
//            if shouldDelete {
            
            let alertController = UIAlertController(title: "Delete?", message: "Do you want to delete?", preferredStyle: .alert)
            let alertAction1 = UIAlertAction(title: "Yes", style: .default) { _ in
                let cell: PersonTableViewCell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
                guard let email = cell.emailLabel.text else {   return  }
                self?.interactor?.deleteSelectedData(email: email.replacingOccurrences(of: "Email: ", with: ""))
                //tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.interactor?.getDataToLoad()
            }
            let alertAction2 = UIAlertAction(title: "No", style: .destructive) { _ in
                tableView.reloadData()
            }
            alertController.addAction(alertAction1)
            alertController.addAction(alertAction2)
            
            self?.present(alertController, animated: true)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {[weak self] _,_,_ in
            let cell: PersonTableViewCell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
            guard let email = cell.emailLabel.text else {   return  }
            guard let fullname = cell.nameLabel.text else {return}
            let name = fullname.split(separator: " ")
            let model = PersonModel(firstName: String(name[1]), lastName: String(name[2]), email: email.replacingOccurrences(of: "Email: ", with: ""))
            self?.router?.showUpdateDataScreen(model: model)
        }
        editAction.backgroundColor = .cyan
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {[weak self] _,_,_ in
//            let cell: PersonTableViewCell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
//            guard let email = cell.emailLabel.text else {   return  }
//            self?.interactor?.deleteSelectedData(email: email.replacingOccurrences(of: "Email: ", with: ""))
//            //tableView.deleteRows(at: [indexPath], with: .automatic)
//            self?.interactor?.getDataToLoad()
//        }
//        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") {[weak self] _,_,_ in
            let cell: PersonTableViewCell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
            guard let email = cell.emailLabel.text else {   return  }
            //self?.interactor?.deleteSelectedData(email: email.replacingOccurrences(of: "Email ", with: ""))
            //self?.interactor?.getDataToLoad()
            guard let fullname = cell.nameLabel.text else {return}
            let name = fullname.split(separator: " ")
            let model = PersonModel(firstName: String(name[1]), lastName: String(name[2]), email: email.replacingOccurrences(of: "Email: ", with: ""))
            self?.router?.showUpdateDataScreen(model: model)
        }
        editAction.backgroundColor = .cyan
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension DetailsViewController: DetailsViewControllerProtocol {
    func loadDataToTableView(data: [PersonModel]) {
        modelArray = data
        personTableView.reloadData()
    }
    
    func showLoadDataFailure() {
        router?.showDataLoadFailureAlert()
        Analytics.setUserProperty("failure_alert", forName: "alert_type")
    }
    
    func showDeleteDataSuccess() {
        router?.showDeleteDataSuccess()
        Analytics.setUserProperty("success_alert", forName: "alert_type")
    }
    
    func showDeleteDataFailure() {
        router?.showDeleteDataFailure()
        Analytics.setUserProperty("failure_alert", forName: "alert_type")
    }
}
