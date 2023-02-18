//
//  ChangePlayerNameView.swift
//  Table Tennis Score Watch App
//
//  Created by Toni Sucic on 18/02/2023.
//

import SwiftUI

struct ChangePlayerNameView: View {
    let player: Player
    let playerRepository: PlayerRepository
    @State private var playerName = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(header: Text("Player name"), footer: Text("Enter a custom player name. Leave the field empty to use the default name.")) {
                TextField("Name", text: $playerName, prompt: Text(player.defaultName))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
            }
        }
        .formStyle(GroupedFormStyle())
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    switch player {
                    case .player1:
                        playerRepository.player1Name = playerName.trimmingCharacters(in: .whitespaces)
                    case .player2:
                        playerRepository.player2Name = playerName.trimmingCharacters(in: .whitespaces)
                    }
                    dismiss()
                } label: {
                    Text("Update")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct ChangePlayerNameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangePlayerNameView(player: .player1, playerRepository: PlayerRepository())
        }
    }
}
