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
      HStack(alignment: .firstTextBaseline) {
        Text("\(viewModel.title)")
          .font(.largeTitle)
        Spacer()
        Text("Score: \(viewModel.score)")
          .font(.title2)
      }
      
      AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
        if card.isMatched && !card.isFaceUp {
          Rectangle().opacity(0)
        } else {
          CardView(card: card, gradient: viewModel.gradient)
            .padding(4)
            .onTapGesture {
              viewModel.choose(card)
            }
        }
      }
      .padding(.bottom)
      .foregroundColor(viewModel.color)
      
      Button {
        viewModel.startNewGame()
      } label: {
        Text("New Game")
      }
    }
    .padding(.horizontal)
  }
}

struct CardView: View {
  let card: EmojiMemoryGame.Card
  let gradient: LinearGradient?
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        let dot = Circle()
          .size(width: 5, height: 5)
          .fill(Color.blue)
          .opacity(card.alreadyBeenSeen ? 1 : 0)
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        if card.isFaceUp {
          shape.fill().foregroundColor(.white)
            .overlay(dot)
            .padding()
          shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.blue)
          Text(card.content).font(font(in: geometry.size))
        } else if card.isMatched {
          shape.opacity(0)
        }
        else {
          if let gradient = gradient {
            shape.fill(gradient)
          } else {
            shape.fill()
          }
        }
      }
    }
  }
  
  private func font(in size: CGSize) -> Font {
    Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
  }
  
  private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
    static let fontScale: CGFloat = 0.75
  }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    
//    ContentView(viewModel: game)
//      .preferredColorScheme(.dark)
    EmojiMemoryGameView(viewModel: game)
      .previewDevice("iPhone 11")
      .preferredColorScheme(.light)
//    ContentView(viewModel: game)
//      .previewDevice("iPhone 13 Pro Max")
  }
}
