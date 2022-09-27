//
//  ViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 19/09/2022.
//

import UIKit

class GameViewController: UIViewController {
    var activePlayer = 1
    var firstPlayerButtons = [Int]()
    var secondPlayerButtons = [Int]()
    @IBOutlet var buttons: [UIButton]!
    let winningSets = [[1,2,3], [4,5,6], [7,8,9], [3,6,9], [1,4,7], [2,5,8], [1,5,9], [3,5,7]]
    @IBOutlet weak var firstPlayerScoreLabel: UILabel!
    @IBOutlet weak var secondPlayerScoreLabel: UILabel!
    var firstPlayerScore = 0
    var secondPlayerScore = 0
    
    var userID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonsShape(buttons: buttons)
        self.hideKeyboardWhenTappedAround()
    }


    @IBAction func buttonSelectedEvent(_ sender: Any) {
        let buttonSelected = sender as! UIButton
        playGame(selectedButton: buttonSelected)
    }
    
    func playGame(selectedButton: UIButton){
        if activePlayer == 1 {
            selectedButton.setTitle("X", for: .normal)
            activePlayer = 2
            firstPlayerButtons.append(selectedButton.tag)
        } else {
            selectedButton.setTitle("O", for: .normal)
            activePlayer = 1
            secondPlayerButtons.append(selectedButton.tag)
        }
        selectedButton.isEnabled = false
        changeButtonFont(button: selectedButton)
        findWinner()
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
    
    func changeScore(for player: Int){
        if player == 1{
            firstPlayerScore += 1
            firstPlayerScoreLabel.text = String(firstPlayerScore)
        } else {
            secondPlayerScore += 1
            secondPlayerScoreLabel.text = String(secondPlayerScore)
        }
    }
    
    func findWinner(){
        for x in winningSets {
            let winningSet = Set(x)
            let firstUserButtonsSet = Set(firstPlayerButtons)
            let secondUserButtonsSet = Set(secondPlayerButtons)
            if winningSet.isSubset(of: firstUserButtonsSet) || winningSet.isSubset(of: secondUserButtonsSet) {
                winningAlert()
                changeScore(for: activePlayer)
            }
        }
    }
    
    func winningAlert(){
        let alert = UIAlertController(title: "Congratulations", message: "Player \(activePlayer) Wins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "One more round!", style: .default) { UIAlertAction in
            self.cleanBoard()
        })
        alert.addAction(UIAlertAction(title: "Reset game", style: .default) { UIAlertAction in
            self.cleanBoard()
            self.resetPlayersScore()
        })
        present(alert, animated: true)
    }
    
    func cleanBoard() {
        firstPlayerButtons = []
        secondPlayerButtons = []
        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }
    
    func resetPlayersScore(){
        activePlayer = 1
        firstPlayerScore = 0
        secondPlayerScore = 0
        firstPlayerScoreLabel.text = String(firstPlayerScore)
        secondPlayerScoreLabel.text = String(firstPlayerScore)
    }
}

