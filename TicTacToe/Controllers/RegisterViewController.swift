//
//  RegisterViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    private let database = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        changeShapeOfFields()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(undoTapped))
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailField.text,
              !email.isEmpty,
              let password = passwordField.text,
              !password.isEmpty,
              password.count >= 6 else {
            errorCreatingUserAlert()
            return
        }
        if checkPassword() {
            let safeEmail = safeEmail(emailAdress: email)
            
            database.child("tictactoe").child("users").child(safeEmail).observeSingleEvent(of: .value,
                                                                                           with: { snapshot in
                guard !snapshot.exists() else {
                    self.userExistsAlert()
                    return
                }
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
                    
                    guard authResult != nil, error == nil,
                          let userid = authResult?.user.uid,
                          let userEmail = authResult?.user.email else {
                        self.errorCreatingUserAlert()
                        return
                    }
                    self.database.child("tictactoe").child("users").child(self.safeEmail(emailAdress: userEmail)).child("Request").setValue(userid)
                    self.navigationController?.dismiss(animated: true)
                    UserDefaults.standard.set(email, forKey: "email")
                    NotificationCenter.default.post(name: .didLogInNotification, object: nil)
                }
            })
            }
    }
    func checkPassword() -> Bool{
        guard let password = passwordField.text,
              let confirmedPassword = confirmPassword.text else {
            return false
        }
        return password == confirmedPassword
    }
    
    func safeEmail(emailAdress: String) -> String {
        let splitArray = emailAdress.split(separator: "@")
        return String(splitArray[0])
    }
    func errorCreatingUserAlert(){
        let alert = UIAlertController(title: "Error creating user.", message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    func userExistsAlert(){
        let alert = UIAlertController(title: "Error creating user.", message: "User with that email address already exists, try different email. ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    @objc func undoTapped(){
        navigationController?.dismiss(animated: false)
    }
    func changeShapeOfFields(){
        emailField.layer.cornerRadius = emailField.frame.size.height/2
        passwordField.layer.cornerRadius = passwordField.frame.size.height/2
        confirmPassword.layer.cornerRadius = passwordField.frame.size.height/2
        
        emailField.layer.borderWidth = 1
        passwordField.layer.borderWidth = 1
        confirmPassword.layer.borderWidth = 1
        
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        confirmPassword.layer.borderColor = UIColor.lightGray.cgColor
        
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordField.leftViewMode = .always
        passwordField.isSecureTextEntry = true
        confirmPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        confirmPassword.isSecureTextEntry = true
        confirmPassword.leftViewMode = .always
    }
}
