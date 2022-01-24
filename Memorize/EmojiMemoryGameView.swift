//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  @State private var dealt = Set<Int>()
  @State private var newDealing = true
  
  @Namespace private var dealingNamespace
  
  init(viewModel: EmojiMemoryGame) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        gameInfo
        gameBody
        gameButtons
          .padding(.horizontal)
      }
      deckBody
    }
    .padding()
  }
  
  private func deal(_ card: EmojiMemoryGame.Card) {
    dealt.insert(card.id)
  }
  
  private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
    !dealt.contains(card.id)
  }
  
  private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
    var delay = 0.0
    if let index = viewModel.cards.firstIndex(where: { $0.id == card.id }) {
      delay = Double(index) * (CardConstants.totalDealDuration / Double(viewModel.cards.count))
    }
    return Animation.easeInOut(duration: CardConstants.totalDealDuration).delay(delay)
  }
  
  private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
    -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
  }
  
  var gameInfo: some View {
    HStack(alignment: .firstTextBaseline) {
      Text("\(viewModel.title)")
        .font(.largeTitle)
      Spacer()
      Text("Score: \(viewModel.score)")
        .font(.title2)
    }
  }
  
  var gameBody: some View {
    AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
      if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
         Color.clear
      } else {
        CardView(card: card, gradient: viewModel.gradient)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .padding(4)
          .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
          .zIndex(zIndex(of: card))
          .onTapGesture {
            withAnimation {
              viewModel.choose(card)
            }
          }
      }
    }
    .padding(.bottom)
    .foregroundColor(viewModel.color)
  }
  
  var gameButtons: some View {
    HStack {
      Button {
        withAnimation {
          dealt = []
          newDealing = true
          viewModel.startNewGame()
        }
      } label: {
        Text("New Game")
      }
      Spacer()
      Button("Shuffle") {
        withAnimation {
          viewModel.shuffle()
        }
      }
    }
  }
  
  var deckBody: some View {
    ZStack {
      // HACK: - if we go just with `.identity` transition it leaves artifacts
      // on new game start: if new count of cards is less than the previous one
      // all cards can be seen, because `.identity` transition doesn't know how to remove them
      // `.opacity` transition removes those "artefacts" but cards duplication can be observed
      // on dealing, like two half-opaque cards are merging into single one.
      // So we need to support both types.
      // Extracting this logic into conditional method doesn't work.
      // For now I couldn't find a better way to work around this.
      if newDealing {
        ForEach(viewModel.cards.filter(isUndealt)) { card in
          CardView(card: card, gradient: viewModel.gradient)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
            .zIndex(zIndex(of: card))
        }
      } else {
        ForEach(viewModel.cards.filter(isUndealt)) { card in
          CardView(card: card, gradient: viewModel.gradient)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            .zIndex(zIndex(of: card))
        }
      }
      
    }
    .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    .foregroundColor(viewModel.color)
    .onTapGesture {
      newDealing = false
      for card in viewModel.cards {
        withAnimation(dealAnimation(for: card)) {
          deal(card)
        }
      }
    }
  }
  
  private struct CardConstants {
    static let aspectRatio: CGFloat = 2/3
    static let dealDuration: Double = 0.5
    static let totalDealDuration: Double = 2
    static let undealtHeight: CGFloat = 90
    static let undealtWidth: CGFloat = undealtHeight * aspectRatio
  }
}

struct CardView: View {
  let card: EmojiMemoryGame.Card
  let gradient: LinearGradient?
  
  @State private var animatedBonusRemaining: Double = 0
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Group {
          if card.isConsumingBonusTime {
            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - animatedBonusRemaining)*360-90))
              .onAppear {
                animatedBonusRemaining = card.bonusRemaining
                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                  animatedBonusRemaining = 0
                }
              }
          } else {
            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 - card.bonusRemaining)*360-90))
          }
        }
        .padding(5)
        .opacity(0.5)
        Text(card.content)
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
          .padding(5)
          .font(Font.system(size: DrawingConstants.fontSize))
          .scaleEffect(scale(thatFits: geometry.size))
      }
      .cardify(isFaceUp: card.isFaceUp, alreadyBeenSeen: card.alreadyBeenSeen, gradient: gradient)
    }
  }
  
  private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
  }
  
  private struct DrawingConstants {
    static let fontScale: CGFloat = 0.65
    static let fontSize: CGFloat = 32
  }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame(with: ThemeStore(named: "Preview").theme(at: 0))
    game.choose(game.cards.first!)
    
//    ContentView(viewModel: game)
//      .preferredColorScheme(.dark)
    return EmojiMemoryGameView(viewModel: game)
      .previewDevice("iPhone 11")
      .preferredColorScheme(.light)
//    ContentView(viewModel: game)
//      .previewDevice("iPhone 13 Pro Max")
  }
}
