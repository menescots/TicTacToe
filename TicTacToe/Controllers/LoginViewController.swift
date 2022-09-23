//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeShapeOfFields()
        
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registerVC") as? RegisterViewController
            self.navigationController?.pushViewController(vc!, animated: true)
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
