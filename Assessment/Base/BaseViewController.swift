//
//  BaseViewController.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit
import PKHUD

protocol BaseViewControllerProtocol {
    func bindViewModel()
    func setupUI()
}

extension BaseViewControllerProtocol {
    
    func bindViewModel(){}
    func setupUI(){}
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func presentAlert(withTitle title: String,
                      message: String,
                      actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
    
        let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        
        actions.forEach { action in
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }

    //MARK: - Progress Spinner
    public func showSpinner(onView: UIView? = nil) {
        DispatchQueue.main.async {
            HUD.show(.progress, onView: onView)
        }
    }
    
    public func hideSpinner() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }

}
