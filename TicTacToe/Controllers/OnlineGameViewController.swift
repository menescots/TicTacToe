//
//  OnlineGameViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 26/09/2022.
//
import UIKit
import Firebase

class OnlineGameViewController: UIViewController {
    var activePlayer = 1
    var firstPlayerButtons = [Int]()
    var secondPlayerButtons = [Int]()
    @IBOutlet var buttons: [UIButton]!
    let winningSets = [[1,2,3], [4,5,6], [7,8,9], [3,6,9], [1,4,7], [2,5,8], [1,5,9], [3,5,7]]
    @IBOutlet weak var firstPlayerScoreLabel: UILabel!
    @IBOutlet weak var secondPlayerScoreLabel: UILabel!
    var firstPlayerScore = 0
    var secondPlayerScore = 0
    var playerSymbol: String?
    var sessionID: String?
    
    @IBOutlet weak var requestedPlayerName: UILabel!
    @IBOutlet weak var requestingPlayerName: UILabel!
    @IBOutlet weak var emailRequestField: UITextField!
    var lastMove: String?
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonsShape(buttons: buttons)
        incomingRequests()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func requestButtonTapped(_ sender: Any) {
        
        guard let requestedUserEmail = emailRequestField.text,
              !requestedUserEmail.isEmpty,
              let currentUserEmail = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        self.database.child("tictactoe").child("users").child(self.safeEmail(emailAdress: requestedUserEmail)).child("Request").childByAutoId().setValue(currentUserEmail)
        playerSymbol = "X"
        resetPlayersScore()
        cleanBoard()
        lastMove = nil
        emailRequestField.text = ""
        requestingPlayerName.text = safeEmail(emailAdress: currentUserEmail)
        requestedPlayerName.text = safeEmail(emailAdress: requestedUserEmail)
        playOnline(sessionID: "\(safeEmail(emailAdress: currentUserEmail))_\(safeEmail(emailAdress: requestedUserEmail))")
    }
    
    func safeEmail(emailAdress: String) -> String {
        let splitArray = emailAdress.split(separator: "@")
        return String(splitArray[0])
    }
    
    func resetPlayersScore(){
        activePlayer = 1
        firstPlayerScore = 0
        secondPlayerScore = 0
        firstPlayerScoreLabel.text = String(firstPlayerScore)
        secondPlayerScoreLabel.text = String(firstPlayerScore)
    }
    @IBAction func acceptButtonTapped(_ sender: Any) {
        guard let requestedUserEmail = emailRequestField.text,
              !requestedUserEmail.isEmpty,
              let currentUserEmail = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        self.database.child("tictactoe").child("users").child(self.safeEmail(emailAdress: requestedUserEmail)).child("Request").childByAutoId().setValue(currentUserEmail)
        playerSymbol = "O"
        resetPlayersScore()
        cleanBoard()
        lastMove = nil
        emailRequestField.text = ""
        requestingPlayerName.text = safeEmail(emailAdress: requestedUserEmail)
        requestedPlayerName.text = safeEmail(emailAdress: currentUserEmail)

        playOnline(sessionID: "\(safeEmail(emailAdress: requestedUserEmail))_\(safeEmail(emailAdress: currentUserEmail))")
    }
    @IBAction func buttonSelectedEvent(_ sender: Any) {
        let buttonSelected = sender as! UIButton
        guard let sessionID = sessionID ,
        let currentUserEmail = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        database.child("tictactoe").child("PlayingOnline").child(sessionID).child("last_move").observe(.value, with: { snapshot in
            guard let lastMoveUser = snapshot.value as? String else {
                return
            }
            self.lastMove = lastMoveUser
        })
        guard lastMove != currentUserEmail else {
            return
        }
        database.child("tictactoe").child("PlayingOnline").child(sessionID).child("last_move").setValue(currentUserEmail)
        database.child("tictactoe").child("PlayingOnline").child(sessionID).child("moves").child("\(buttonSelected.tag)").setValue(currentUserEmail)
    }
    
    func incomingRequests(){
        guard let currentUserEmail = Firebase.Auth.auth().currentUser?.email,
              let currentUserUID = Firebase.Auth.auth().currentUser?.uid else {
            return
        }
        self.database.child("tictactoe").child("users").child(self.safeEmail(emailAdress: currentUserEmail )).child("Request").observe(.value, with: { snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let playerRequest = snap.value as? String {
                        self.emailRequestField.text = playerRequest
                        self.database.child("tictactoe").child("users").child(self.safeEmail(emailAdress: currentUserEmail )).child("Request").setValue(currentUserUID)
                    }
                }
            }
                
        })
    }
    func buttonTagToButton(selectedButtonTag: Int){
        for button in buttons {
            if button.tag == selectedButtonTag {
                changeButtonFont(button: button)
                playGame(selectedButton: button)
                button.isEnabled = false
            }
        }
        findWinner()
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
        guard let sessionID = sessionID else {
            return
        }

        let alert = UIAlertController(title: "Congratulations", message: "Player \(activePlayer) Wins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "One more round!", style: .cancel) { UIAlertAction in
            print(self.firstPlayerScore,self.secondPlayerScore)
            self.cleanBoard()
            self.database.child("tictactoe").child("PlayingOnline").child(sessionID).removeValue()
        })
        present(alert, animated: true)
    }
    
    func cleanBoard() {
        firstPlayerButtons.removeAll()
        secondPlayerButtons.removeAll()
        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }
    
    func playOnline(sessionID: String){
        self.sessionID = sessionID
        
        guard let currentUserEmail = Firebase.Auth.auth().currentUser?.email else {
            return
        }
        
        database.child("tictactoe").child("PlayingOnline").child(sessionID).removeValue()
        database.child("tictactoe").child("PlayingOnline").child(sessionID).child("moves").observe(.value, with: { snapshot in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.firstPlayerButtons.removeAll()
                self.secondPlayerButtons.removeAll()
                for snap in snapshot {
                    if let playerEmail = snap.value as? String {
                        let buttonID = snap.key
                        if playerEmail == currentUserEmail {
                            self.activePlayer = self.playerSymbol == "X" ? 1: 2
                        } else {
                            self.activePlayer = self.playerSymbol == "X" ? 2: 1
                        }
                        self.buttonTagToButton(selectedButtonTag: Int(buttonID)!)
                    }
                }
            }
                
        })
    }
}


