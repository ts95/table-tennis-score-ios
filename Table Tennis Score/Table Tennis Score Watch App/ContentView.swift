//
//  ContentView.swift
//  Table Tennis Score Watch App
//
//  Created by Toni Sucic on 16/02/2023.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @StateObject private var scoreRepository = TableTennisScoreRepository()
    @StateObject private var playerRepository = PlayerRepository()

    @State private var tabSelection = Tab.game
    @State private var pickedServingPlayer = false

    enum Tab {
        case actions
        case game
    }

    var body: some View {
        TabView(selection: $tabSelection) {
            actionsView
                .tag(Tab.actions)

            gameView
                .tag(Tab.game)
        }
    }

    @ViewBuilder var actionsView: some View {
        NavigationView {
            List {
                Section("Actions") {
                    Button {
                        scoreRepository.undoLastPoint()
                        playHaptic(.click)
                    } label: {
                        Text("Undo last point")
                    }
                    .disabled(scoreRepository.gameHistory.isEmpty)

                    Button {
                        scoreRepository.game.initiallyServingPlayer = scoreRepository.game.initiallyServingPlayer.other
                        playHaptic(.click)
                    } label: {
                        Text("Switch serve")
                    }
                    .disabled(!pickedServingPlayer)

                    Button(role: .destructive) {
                        pickedServingPlayer = false
                        scoreRepository.reset()
                        playHaptic(.click)
                    } label: {
                        Text("Reset game")
                    }
                    .disabled(!pickedServingPlayer)
                }

                Section("Players") {
                    ForEach(Player.allCases) { player in
                        NavigationLink {
                            ChangePlayerNameView(player: player, playerRepository: playerRepository)
                        } label: {
                            HStack {
                                Text(playerRepository.playerName(for: player))

                                Spacer()

                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder var gameView: some View {
        NavigationView {
            Group {
                if pickedServingPlayer {
                    if let winner = scoreRepository.game.winner {
                        gameWonView(winner: winner)
                    } else {
                        activeGameView
                    }
                } else {
                    servingPlayerPicker
                }
            }
            .navigationTitle("Table Tennis")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder var servingPlayerPicker: some View {
        VStack(spacing: 16) {
            Text("Who serves first?")

            Button {
                scoreRepository.game.initiallyServingPlayer = .player1
                pickedServingPlayer = true
                playHaptic(.click)
            } label: {
                Text(playerRepository.playerName(for: .player1))
            }

            Button {
                scoreRepository.game.initiallyServingPlayer = .player2
                pickedServingPlayer = true
                playHaptic(.click)
            } label: {
                Text(playerRepository.playerName(for: .player2))
            }
        }
    }

    @ViewBuilder var activeGameView: some View {
        VStack(spacing: 16) {
            Button {
                if scoreRepository.scorePoint(for: .player1) {
                    playHaptic(.success)
                } else {
                    playHaptic(.click)
                }
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.game.player1Score)")
                        .frame(width: 40, alignment: .trailing)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text(playerRepository.playerName(for: .player1))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .overlay(alignment: .bottom) {
                if scoreRepository.game.servingPlayer == .player1 {
                    servesBadge
                        .offset(x: 0, y: 8)
                        .allowsHitTesting(false)
                }
            }

            Button {
                if scoreRepository.scorePoint(for: .player2) {
                    playHaptic(.success)
                } else {
                    playHaptic(.click)
                }
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.game.player2Score)")
                        .frame(width: 40, alignment: .trailing)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text(playerRepository.playerName(for: .player2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
            .overlay(alignment: .bottom) {
                if scoreRepository.game.servingPlayer == .player2 {
                    servesBadge
                        .offset(x: 0, y: 8)
                        .allowsHitTesting(false)
                }
            }
        }
        .bold()
        .padding(.top, 12)
        .padding(.bottom, 24)
        .ignoresSafeArea(.all, edges: .bottom)
    }

    @ViewBuilder var servesBadge: some View {
        Text("Serves")
            .font(.footnote)
            .textCase(.uppercase)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(16)
    }

    @ViewBuilder func gameWonView(winner: Player) -> some View {
        VStack(spacing: 24) {
            Group {
                Text("\(playerRepository.playerName(for: winner)) won!")
            }
            .font(.title3)

            Button {
                scoreRepository.reset()
                pickedServingPlayer = false
                playHaptic(.click)
            } label: {
                Text("New game")
            }
        }
    }

    func playHaptic(_ hapticType: WKHapticType) {
        WKInterfaceDevice.current().play(hapticType)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 41mm"))
                .previewDisplayName("41 mm")

            ContentView()
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 7 - 45mm"))
                .previewDisplayName("45 mm")
        }
    }
}
