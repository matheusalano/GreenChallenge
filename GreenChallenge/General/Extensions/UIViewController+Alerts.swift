//
//  UIViewController+Alerts.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}
