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
    @Published var player1Score = 0
    @Published var player2Score = 0
    @Published var initiallyServingPlayer: Player = .player1

    var servingPlayer: Player {
        (player1Score + player2Score) % 4 < 2 ? initiallyServingPlayer : initiallyServingPlayer.other
    }

    var winner: Player? {
        if player1Score >= 11 || player2Score >= 11 {
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

    func scorePoint(for player: Player) {
        switch player {
        case .player1:
            player1Score += 1
        case .player2:
            player2Score += 1
        }
    }

    func reset() {
        player1Score = 0
        player2Score = 0
    }
}
