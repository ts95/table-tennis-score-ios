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
                    } label: {
                        Text("Undo last point")
                    }
                    .disabled(scoreRepository.gameHistory.isEmpty)

                    Button {
                        scoreRepository.game.initiallyServingPlayer = scoreRepository.game.initiallyServingPlayer.other
                    } label: {
                        Text("Switch serve")
                    }

                    Button(role: .destructive) {
                        pickedServingPlayer = false
                        scoreRepository.reset()
                    } label: {
                        Text("Reset game")
                    }
                    .disabled(!pickedServingPlayer)
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
            } label: {
                Text("Player #1")
            }

            Button {
                scoreRepository.game.initiallyServingPlayer = .player2
                pickedServingPlayer = true
            } label: {
                Text("Player #2")
            }
        }
    }

    @ViewBuilder var activeGameView: some View {
        VStack(spacing: 16) {
            Button {
                if scoreRepository.scorePoint(for: .player1) {
                    WKInterfaceDevice.current().play(.success)
                } else {
                    WKInterfaceDevice.current().play(.click)
                }
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.game.player1Score)")
                        .frame(width: 32)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text("Player #1")
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
                    WKInterfaceDevice.current().play(.success)
                } else {
                    WKInterfaceDevice.current().play(.click)
                }
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.game.player2Score)")
                        .frame(width: 32)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text("Player #2")
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
                switch winner {
                case .player1:
                    Text("Player #1 won!")
                case .player2:
                    Text("Player #2 won!")
                }
            }
            .font(.title3)

            Button {
                scoreRepository.reset()
                pickedServingPlayer = false
            } label: {
                Text("New game")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
