//
//  HomeVC.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/1/22.
//

import UIKit

class HomeVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.bindViewModel()
    }
    

    func bindViewModel() {
        
        viewModel.changeHandler = {
            [unowned self] change in
            
            switch change {
            case .loaderStart:
                self.showSpinner()
                break
            case .loaderEnd:
                self.hideSpinner()
                break
            case .error(let message):
                self.presentAlert(withTitle: "Error", message: message)
                break
            case .success(let message):
                break
            case .updateDataModel:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            }
        }
        
        viewModel.startSyncing()
    }
    
    func setupUI() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

}

//MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = viewModel.offers[indexPath.section].offer_detail?[indexPath.row]
        
        let cell: UITableViewCell
        if let newCell = tableView.dequeueReusableCell(withIdentifier: "myCell") {
            cell = newCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
            cell.detailTextLabel?.numberOfLines = 0
        }
        cell.textLabel?.text = model?.offer_name
        cell.detailTextLabel?.text = model?.offer_desc
        
        return cell;
    }
}

//MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.offers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.offers[section].offer_detail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.offers[section].offer_type.rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
