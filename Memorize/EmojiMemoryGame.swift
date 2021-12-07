//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.11.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
  init() {
    let theme = EmojiMemoryGame.getRandomTheme()
    self.theme = theme
    model = EmojiMemoryGame.createMemoryGame(theme: theme)
  }
  
  static func getRandomTheme() -> Theme {
    Theme.all.randomElement()!
//    Theme.all[Int.random(in: 0..<Theme.all.count)]
  }
  
  static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
    let numbersOfCardsToPlay = min(theme.numberOfPairsOfCardsToShow, theme.emojis.count)
    
    return MemoryGame<String>(numberOfPairsOfCards: numbersOfCardsToPlay) { pairIndex in
      theme.emojis[pairIndex]
    }
  }
  
  @Published private var model: MemoryGame<String>
  @Published private var theme: Theme
  
  var cards: Array<MemoryGame<String>.Card> {
    return model.cards
  }
  
  var color: Color {
    Color.fromString(theme.color)
  }
  
  var title: String {
    theme.name
  }
  
  var score: Int {
    model.score
  }
  
  // MARK: - Intent(s)
  
  func choose(_ card: MemoryGame<String>.Card) {
    model.choose(card)
  }
  
  func startNewGame() {
    let theme = EmojiMemoryGame.getRandomTheme()
    self.theme = theme
    model = EmojiMemoryGame.createMemoryGame(theme: theme)
  }
}
