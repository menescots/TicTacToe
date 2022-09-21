//
//  ViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 19/09/2022.
//

import UIKit

class ViewController: UIViewController {
    var activePlayer = 1
    var firstPlayerButtons = [Int]()
    var secondPlayerButtons = [Int]()
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonsShape(buttons: buttons)
    }


    @IBAction func buttonSelectedEvent(_ sender: Any) {
        let buttonSelected = sender as! UIButton
        playGame(selectedButton: buttonSelected)
    }
    
    func playGame(selectedButton: UIButton){
        if activePlayer == 1 {
            selectedButton.setTitle("X", for: .normal)
            activePlayer = 2
            selectedButton.isEnabled = false
            firstPlayerButtons.append(selectedButton.tag)
        } else {
            selectedButton.setTitle("O", for: .normal)
            activePlayer = 1
            secondPlayerButtons.append(selectedButton.tag)
        }
        changeButtonFont(button: selectedButton)
    }
    
    func changeButtonFont(button: UIButton){
        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 60)
    }
    func changeButtonsShape(buttons: [UIButton]){
        for button in buttons {
            button.clipsToBounds = true
            button.layer.cornerRadius = button.layer.bounds.width/2-5
        }
    }
}

