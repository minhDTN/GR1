//
//  UIViewControllerExtension.swift
//  dominGR1
//
//  Created by Macbook on 12/07/2022.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemRed.cgColor, UIColor.systemOrange.cgColor]
        gradient.locations = [0, 0.5 , 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    func showLoader(_ show: Bool) {
        view.endEditing(true)

        if show {
            print("DEBUG: show loader")
            UIViewController.hud.show(in: view)
            UIViewController.hud.textLabel.text = "Loading"
        } else {
            print("DEBUG: end loader")
            UIViewController.hud.dismiss()
        }
    }
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

