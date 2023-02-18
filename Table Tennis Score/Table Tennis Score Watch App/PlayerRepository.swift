//
//  PlayerRepository.swift
//  Table Tennis Score Watch App
//
//  Created by Toni Sucic on 18/02/2023.
//

import Foundation

class PlayerRepository: ObservableObject {
    @Published var player1Name = ""
    @Published var player2Name = ""

    func playerName(for player: Player) -> String {
        switch player {
        case .player1:
            return player1Name.isEmpty ? player.defaultName : player1Name
        case .player2:
            return player2Name.isEmpty ? player.defaultName : player2Name
        }
    }
}
