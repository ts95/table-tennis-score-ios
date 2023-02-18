//
//  TableTennisScoreRepository.swift
//  Table Tennis Score Watch App
//
//  Created by Toni Sucic on 16/02/2023.
//

import Foundation

enum Player {
    case player1
    case player2

    var other: Player {
        switch self {
        case .player1:
            return .player2
        case .player2:
            return .player1
        }
    }
}

class TableTennisScoreRepository: ObservableObject {
    @Published var game = Game()

    var gameHistory = [Game]()

    /// Returns true if the scored point won the game.
    func scorePoint(for player: Player) -> Bool {
        gameHistory.append(game)

        switch player {
        case .player1:
            game.player1Score += 1
        case .player2:
            game.player2Score += 1
        }

        return game.winner != nil
    }

    func undoLastPoint() {
        if let lastGame = gameHistory.popLast() {
            game = lastGame
        }
    }

    func reset() {
        gameHistory.removeAll()
        game = Game()
    }

    struct Game: Hashable {
        var player1Score = 0
        var player2Score = 0
        var initiallyServingPlayer: Player = .player1
        let winningScore = 11

        var totalScore: Int {
            player1Score + player2Score
        }

        var servingPlayer: Player {
            if player1Score >= 10 && player2Score >= 10 {
                return totalScore % 2 == 0 ? initiallyServingPlayer : initiallyServingPlayer.other
            }
            return totalScore % 4 < 2 ? initiallyServingPlayer : initiallyServingPlayer.other
        }

        var winner: Player? {
            if player1Score >= winningScore || player2Score >= winningScore {
                if player1Score - player2Score - 2 >= 0 {
                    return .player1
                } else if player2Score - player1Score - 2 >= 0 {
                    return .player2
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
}
