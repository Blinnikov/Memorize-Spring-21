//
//  MemoryGame.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.11.2021.
//

import Foundation

struct MemoryGame<CardContent> {
  private(set) var cards: Array<Card>
  
  mutating func choose(_ card: Card) {
    if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
      cards[chosenIndex].isFaceUp.toggle()
    }
  }
  
  init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
    cards = Array<Card>()
    
    for pairIndex in 0..<numberOfPairsOfCards {
      let content = createCardContent(pairIndex)
      cards.append(Card(content: content, id: pairIndex * 2))
      cards.append(Card(content: content, id: pairIndex * 2 + 1))
    }
  }
  
  struct Card: Identifiable {
    var isFaceUp: Bool = true
    var isMatched: Bool = true
    var content: CardContent
    var id: Int
  }
}
