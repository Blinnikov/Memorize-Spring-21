//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  
  init(viewModel: EmojiMemoryGame) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      gameInfo
      gameBody
      gameButtons
    }
    .padding()
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
      if card.isMatched && !card.isFaceUp {
        Color.clear
      } else {
        CardView(card: card, gradient: viewModel.gradient)
          .padding(4)
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
      Spacer()
      Button {
        withAnimation {
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
      Spacer()
    }
  }
}

struct CardView: View {
  let card: EmojiMemoryGame.Card
  let gradient: LinearGradient?
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
          .padding(5).opacity(0.5)
        Text(card.content)
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
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
    let game = EmojiMemoryGame()
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
