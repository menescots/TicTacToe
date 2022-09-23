//
//  MenuViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 23/09/2022.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func twoPlayerGameTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BoardVC") as? GameViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func onePlayerGameTapped(_ sender: Any) {
        
    }
    
    @IBAction func playOnlineGameTapped(_ sender: Any) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
            self.navigationController?.pushViewController(vc!, animated: true)
    }
}
