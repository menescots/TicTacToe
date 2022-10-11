//
//  AIBoard.swift
//  TicTacToe
//
//  Created by Agata Menes on 10/10/2022.
//

import Foundation

class AIBoard {
    var boardState: [Int]
    var winningSets = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    
    init(boardState: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]){
        self.boardState = boardState
    }
}

extension AIBoard {
    func resetBoardState() {
        self.boardState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    }
    
    func getBoardState() -> [Int] {
        return self.boardState
    }
    
    func addMove(player: Int, atPosition:Int) {
        
        self.boardState[atPosition] = player
    }
    
    func getMove(atPosition:Int!) -> Int {
        return self.boardState[atPosition]
    }
    
    func checkGameStatus() -> TicTacToeAI.gameStatus{
        for winningSet in winningSets{
            if boardState[winningSet[0]] != 0 && boardState[winningSet[0]] == boardState[winningSet[1]] && boardState[winningSet[1]] == boardState[winningSet[2]] {
                if boardState[winningSet[0]] == 1{
                    return TicTacToeAI.gameStatus.humanWin
                }else{
                    return TicTacToeAI.gameStatus.computerWin
                }
            }
            
        }
        if !boardState.contains(0) {
            return TicTacToeAI.gameStatus.draw
        }
        
        return TicTacToeAI.gameStatus.inProgress
    }
    
    func getAvailableMoves() -> [Int]{
        var boardCopy = self.boardState;
        var availableMoves:[Int] = []
        var index = boardCopy.firstIndex(of: 0)
        while index  != nil {
            availableMoves.append(index!)
            boardCopy[index!] = -1
            index = boardCopy.firstIndex(of: 0)
        }
        return availableMoves
    }
    
}
