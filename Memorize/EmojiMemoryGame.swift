//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.11.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
  typealias Card = MemoryGame<String>.Card
  
  init(with theme: Theme) {
    self.theme = theme
    model = EmojiMemoryGame.createMemoryGame(theme: theme)
  }
  
  private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
    let numbersOfCardsToPlay = min(theme.numberOfPairsOfCardsToShow, theme.emojis.count)
    
    return MemoryGame<String>(numberOfPairsOfCards: numbersOfCardsToPlay) { pairIndex in
      theme.emojis[pairIndex]
    }
  }
  
  @Published private var model: MemoryGame<String>
  @Published private var theme: Theme
  
  var cards: Array<Card> {
    return model.cards
  }
  
  var color: Color {
    Color(rgbaColor: theme.rgbaColor)
  }
  
  var title: String {
    theme.name
  }
  
  var score: Int {
    model.score
  }
  
  // MARK: - Intent(s)
  
  func choose(_ card: Card) {
    model.choose(card)
  }
  
  func startNewGame() {
    model = EmojiMemoryGame.createMemoryGame(theme: theme)
  }
  
  func shuffle() {
    model.shuffle()
  }
}
