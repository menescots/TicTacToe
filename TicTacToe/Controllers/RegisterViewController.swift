//
//  RegisterViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeShapeOfFields()
    }
 
    @IBAction func registerButtonTapped(_ sender: Any) {
    }
    
    func changeShapeOfFields(){
        emailField.layer.cornerRadius = emailField.frame.size.height/2
        passwordField.layer.cornerRadius = passwordField.frame.size.height/2
        confirmPassword.layer.cornerRadius = passwordField.frame.size.height/2
        
        emailField.layer.borderWidth = 1
        passwordField.layer.borderWidth = 1
        confirmPassword.layer.borderWidth = 1
        
        emailField.layer.borderColor = UIColor.darkGray.cgColor
        passwordField.layer.borderColor = UIColor.darkGray.cgColor
        confirmPassword.layer.borderColor = UIColor.darkGray.cgColor
        
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) //
        emailField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) //
        passwordField.leftViewMode = .always
        confirmPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) //
        confirmPassword.leftViewMode = .always
    }
}
