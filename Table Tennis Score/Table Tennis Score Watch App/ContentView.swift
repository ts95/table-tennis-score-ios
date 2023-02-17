//
//  ContentView.swift
//  Table Tennis Score Watch App
//
//  Created by Toni Sucic on 16/02/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var scoreRepository = TableTennisScoreRepository()

    @State private var pickedServingPlayer = false

    var body: some View {
        NavigationView {
            Group {
                if pickedServingPlayer {
                    if let winner = scoreRepository.winner {
                        gameWonView(winner: winner)
                    } else {
                        gameView
                    }
                } else {
                    servingPlayerPicker()
                }
            }
            .navigationTitle("Table Tennis")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder func servingPlayerPicker() -> some View {
        VStack(spacing: 16) {
            Text("Who serves first?")

            Button {
                scoreRepository.initiallyServingPlayer = .player1
                pickedServingPlayer = true
            } label: {
                Text("Player #1")
            }

            Button {
                scoreRepository.initiallyServingPlayer = .player2
                pickedServingPlayer = true
            } label: {
                Text("Player #2")
            }
        }
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

    @ViewBuilder var gameView: some View {
        VStack(spacing: 16) {
            Button {
                scoreRepository.scorePoint(for: .player1)
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.player1Score)")
                        .frame(width: 32)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text("Player #1")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 2)
            )
            .overlay(alignment: .bottom) {
                if scoreRepository.servingPlayer == .player1 {
                    servesBadge
                        .offset(x: 0, y: 8)
                }
            }

            Button {
                scoreRepository.scorePoint(for: .player2)
            } label: {
                HStack(spacing: 18) {
                    Text("\(scoreRepository.player2Score)")
                        .frame(width: 32)

                    Divider()
                        .background(Color.white)
                        .frame(height: 24)

                    Text("Player #2")
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .cornerRadius(16)
            .overlay(alignment: .bottom) {
                if scoreRepository.servingPlayer == .player2 {
                    servesBadge
                        .offset(x: 0, y: 8)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
