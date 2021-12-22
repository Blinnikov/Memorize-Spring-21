//
//  MemoryGame.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.11.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  private(set) var cards: Array<Card>
  private(set) var score = 0
  
  private var indexOfTheOneAndOnlyFaceUpCard: Int? {
    get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
    set { cards.indices.forEach{ cards[$0].isFaceUp = $0 == newValue }}
  }
  
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
        
        cards[chosenIndex].isFaceUp = true
      } else {
        // Always turn ALL cards face down on selecting first element in the pair (initial selection or selection after a mismatch)
        indexOfTheOneAndOnlyFaceUpCard = chosenIndex
      }
    }
  }
  
  mutating func shuffle() {
    cards.shuffle()
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
    var isFaceUp = false {
      willSet {
        // When turning card face down that previously was face up - that means it already has been seen
        if !newValue && isFaceUp {
          alreadyBeenSeen = true
        }
      }
      didSet {
        if isFaceUp {
          startUsingBonusTime()
        } else {
          stopUsingBonusTime()
        }
      }
    }
    var isMatched = false {
      didSet {
        stopUsingBonusTime()
      }
    }
    var alreadyBeenSeen = false
    let content: CardContent
    let id: Int
    
    // MARK: - Bonus Time
    
    // this could give matching bonus points
    // if the user matches the card
    // before a certain amount of time passes during which the card is face up
    
    // can be zero which means "mo bonus available" for this card
    var bonusTimeLimit: TimeInterval = 6
    
    private var faceUpTime: TimeInterval {
      if let lastFaceUpDate = self.lastFaceUpDate {
        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
      } else {
        return pastFaceUpTime
      }
    }
    
    // the last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?
    // the accumulated time this card has been face up in the past
    // (i.e. not including the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0
    
    // how much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
      max(0, bonusTimeLimit - faceUpTime)
    }
    // percentage of the bonus time remaining
    var bonusRemaining: Double {
      (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
    }
    // whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
      isMatched && bonusTimeRemaining > 0
    }
    // whether we are currenty face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
      isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    // called when the card transitions to face up state
    private mutating func startUsingBonusTime() {
      if isConsumingBonusTime, lastFaceUpDate == nil {
        lastFaceUpDate = Date()
      }
    }
    // called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
      pastFaceUpTime = faceUpTime
      self.lastFaceUpDate = nil
    }
  }
}

extension Array {
  var oneAndOnly: Element? {
    count == 1 ? first : nil
  }
}
