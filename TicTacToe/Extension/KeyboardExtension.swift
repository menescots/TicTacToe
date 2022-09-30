//
//  KeyboardExtension.swift
//  TicTacToe
//
//  Created by Agata Menes on 27/09/2022.
//

import Foundation
import UIKit

class keyboardExtension: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension Notification.Name {
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
