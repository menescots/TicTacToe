//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeShapeOfFields()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
        }
        UserDefaults.standard.set(email, forKey: "email")
        navigationController?.dismiss(animated: true)
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        self.navigationController?.pushViewController(popup, animated: true)
    }
    
    @objc func closeTapped(){
        navigationController?.dismiss(animated: true)
    }
    func changeShapeOfFields(){
        emailField.layer.cornerRadius = emailField.frame.size.height/2
        passwordField.layer.cornerRadius = passwordField.frame.size.height/2
        emailField.layer.borderWidth = 2
        passwordField.layer.borderWidth = 2
        emailField.layer.borderColor = UIColor.darkGray.cgColor
        passwordField.layer.borderColor = UIColor.darkGray.cgColor
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) //
        emailField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) //
        passwordField.leftViewMode = .always
    }
}
