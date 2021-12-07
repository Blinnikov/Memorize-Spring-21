//
//  ContentView.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

struct ContentView: View {
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
      
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
          ForEach(viewModel.cards) { card in
            CardView(card: card)
              .aspectRatio(2/3, contentMode: .fit)
              .onTapGesture {
                viewModel.choose(card)
              }
          }
        }
      }
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
  let card: MemoryGame<String>.Card
  
  var body: some View {
    ZStack {
      let dot = Circle()
        .size(width: 5, height: 5)
        .fill(Color.blue)
        .opacity(card.alreadyBeenSeen ? 1 : 0)
      let shape = RoundedRectangle(cornerRadius: 20)
      if card.isFaceUp {
        shape.fill().foregroundColor(.white)
          .overlay(dot)
          .padding()
        shape.strokeBorder(lineWidth: 3)
        Text(card.content).font(.largeTitle)
      } else if card.isMatched {
        shape.opacity(0)
      }
      else {
        shape.fill()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    
//    ContentView(viewModel: game)
//      .preferredColorScheme(.dark)
    ContentView(viewModel: game)
      .previewDevice("iPhone 11")
      .preferredColorScheme(.light)
//    ContentView(viewModel: game)
//      .previewDevice("iPhone 13 Pro Max")
  }
}
