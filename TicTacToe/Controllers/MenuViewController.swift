//
//  MenuViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit
import FirebaseAuth
class MenuViewController: UIViewController {
    @IBOutlet weak var loggedUserLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let loggedUser = UserDefaults.standard.value(forKey: "email") else {
            loggedUserLabel.text = ""
            return
        }
        loggedUserLabel.text = "Logged as \(loggedUser)"
    }
    @IBAction func twoPlayerGameTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BoardVC") as? GameViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Do you want to log out?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Log out",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                print(FirebaseAuth.Auth.auth().currentUser)
            } catch {
                print("Failed to log out.")
            }
        }))
        loggedUserLabel.text = ""
        UserDefaults.standard.removeObject(forKey: "email")
        present(actionSheet, animated: true)
    }
    @IBAction func onePlayerGameTapped(_ sender: Any) {
        
    }
    
    @IBAction func playOnlineGameTapped(_ sender: Any) {
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let popup : LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            let navigationController = UINavigationController(rootViewController: popup)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BoardVC") as? GameViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
