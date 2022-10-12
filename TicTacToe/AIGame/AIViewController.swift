//
//  AIViewController.swift
//  TicTacToe
//
//  Created by Agata Menes on 10/10/2022.
//

import UIKit

class AIViewController: UIViewController {

    @IBOutlet weak var restartGameButton: UIButton!
    var gameActive = true
    var board: AIBoard = AIBoard()
    var AI:TicTacToeAI = TicTacToeAI()
    
    @IBOutlet weak var computerScoreLabel: UILabel!
    @IBOutlet weak var humanScoreLabel: UILabel!
    var computerScore = 0
    var humanScore = 0
    @IBOutlet var buttons: [UIButton]!
    @IBAction func buttonTapped(_ sender: UIButton) {
        if board.getMove(atPosition: sender.tag - 1) == 0 && gameActive{
            sender.setTitle("0", for: .normal)
            changeButtonFont(button: sender)
            self.board.addMove(player: Player.human, atPosition: sender.tag - 1)
            
            gameActive = false
            randomComputerMove()
        }
    }
    private func randomComputerMove() {
        let randomInt = Int.random(in: 1...2)
        let availableMoves = board.getAvailableMoves()
        let randomAvailablePosition = availableMoves.randomElement()
        switch randomInt {
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.playComputerMove()
            }
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let button: UIButton = self.view.viewWithTag(randomAvailablePosition! + 1) as! UIButton
            button.setTitle("X", for: .normal)
                self.changeButtonFont(button: button)
            }
            guard let randomAvailablePosition = randomAvailablePosition else {
                return
            }
            board.addMove(player: Player.computer, atPosition: randomAvailablePosition)
            changeGameStatus()
        default:
            print("default")
        }
    }
    private func playComputerMove(){
        let nextMove = self.AI.nextMove(board: self.board, player: Player.computer)
        if(nextMove >= 0){
            let button: UIButton = self.view.viewWithTag(nextMove + 1) as! UIButton
            button.setTitle("X", for: .normal)
            changeButtonFont(button: button)
            self.board.addMove(player: Player.computer, atPosition: nextMove)
        }
        changeGameStatus()
    }
    
    private func changeGameStatus(){
        let status: TicTacToeAI.gameStatus = self.board.checkGameStatus()
        if(status != TicTacToeAI.gameStatus.inProgress){
            switch status {
            case TicTacToeAI.gameStatus.humanWin:
                humanScore += 1
            case TicTacToeAI.gameStatus.computerWin:
                computerScore += 1
            case TicTacToeAI.gameStatus.draw:
                print("its a draw")
            default:
                break
            }
            gameActive = false
            changeScoreLabel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.resetGame()
            }
        }else{
            gameActive = true
        }
    }
    @IBAction func restartGameTapped(_ sender: Any) {
        resetGame()
        resetScore()
    }
    func resetScore(){
        humanScore = 0
        computerScore = 0
        changeScoreLabel()
    }
    func resetGame() {
        gameActive = true
        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
        board.resetBoardState()
    }
    
    func changeScoreLabel(){
        humanScoreLabel.text = String(humanScore)
        computerScoreLabel.text = String(computerScore)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        randomComputerMove()
        changeButtonsShape(buttons: buttons)
    }
}
