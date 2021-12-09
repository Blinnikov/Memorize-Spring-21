//
//  MemoryGame.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.11.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  private(set) var cards: Array<Card>
  private var indexOfTheOneAndOnlyFaceUpCard: Int?
  private(set) var score = 0
  
  mutating func choose(_ card: Card) {
    if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
       !cards[chosenIndex].isFaceUp,
       !cards[chosenIndex].isMatched {
      if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
        // Match
        if cards[chosenIndex].content == cards[potentialMatchIndex].content {
          cards[chosenIndex].isMatched = true
          cards[potentialMatchIndex].isMatched = true
          score += 2
        }
        // Mismatch
        else {
          if cards[chosenIndex].alreadyBeenSeen {
            score -= 1
          }
          if cards[potentialMatchIndex].alreadyBeenSeen {
            score -= 1
          }
        }
        indexOfTheOneAndOnlyFaceUpCard = nil
      } else {
        // Always turn ALL cards face down on selecting first element in the pair (initial selection or selection after a mismatch)
        for index in cards.indices {
          if cards[index].isFaceUp {
            // When turning card face down that previously was face up - that means it already has been seen
            cards[index].alreadyBeenSeen = true
          }
          cards[index].isFaceUp = false
        }
        indexOfTheOneAndOnlyFaceUpCard = chosenIndex
      }
      cards[chosenIndex].isFaceUp.toggle()
    }
  }
  
  init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
    cards = []
    
    for pairIndex in 0..<numberOfPairsOfCards {
      let content = createCardContent(pairIndex)
      cards.append(Card(content: content, id: pairIndex * 2))
      cards.append(Card(content: content, id: pairIndex * 2 + 1))
    }
    
    cards.shuffle()
  }
  
  struct Card: Identifiable {
    var isFaceUp = false
    var isMatched = false
    var alreadyBeenSeen = false
    let content: CardContent
    let id: Int
  }
}
