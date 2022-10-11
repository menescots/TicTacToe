//
//  AI.swift
//  TicTacToe
//
//  Created by Agata Menes on 10/10/2022.
//

import Foundation

class Player {
    static let human = 1
    static let computer = 2
}

class TicTacToeAI {
    enum gameStatus {
        case humanWin
        case computerWin
        case draw
        case inProgress
    }
    
}

extension TicTacToeAI {
    private func minMax(game:AIBoard, player: Int, depth: Int) -> [Int]{
        //In case the center of the board has not been taken yet, take it first
        if game.boardState[4] == 0{
            return [0, 4]
        }
        let availableMoves: [Int] = game.getAvailableMoves()
        let status: TicTacToeAI.gameStatus = game.checkGameStatus()
        var bestMove = -1
        var bestScore: Int = player == Player.computer ? Int.min : Int.max
        var score: Int
        
        if(status != gameStatus.inProgress || availableMoves.count == 0){
            return evaluateScore(status: status, depth: depth, bestMove: bestMove)
        }
        
        for move in availableMoves{
            let nextGameState: AIBoard = AIBoard(boardState: game.getBoardState())
            nextGameState.addMove(player: player, atPosition: move)
            
            if(player == Player.computer){
                score = minMax(game: nextGameState, player: Player.human, depth: depth + 1)[0]
                if score > bestScore{
                    bestScore = score
                    bestMove = move
                }
            }else{
                score = minMax(game: nextGameState, player: Player.computer, depth: depth + 1)[0]
                if score < bestScore{
                    bestScore = score
                    bestMove = move
                }
            }
        }
        return [bestScore, bestMove]
    }
    
    private func evaluateScore(status: TicTacToeAI.gameStatus, depth: Int, bestMove: Int) -> [Int]{
        if status == gameStatus.humanWin {
            return [depth - 10, bestMove]
        } else {
            if status == gameStatus.computerWin {
                return [10 - depth, bestMove]
            } else {
                return [0, bestMove]
            }
        }
    }
    
    func nextMove(board: AIBoard, player: Int) -> Int{
        return minMax(game: board, player: player, depth: 0)[1]
    }
}
