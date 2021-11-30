//
//  ContentView.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel: EmojiMemoryGame
  
  let vehicles = ["🚲", "🚂", "🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"]
  
  let animals = ["🦧", "🦏", "🐏", "🐈", "🦤", "🦫", "🦥", "🐫", "🐢", "🦭", "🦘", "🐇"]
  
  let sports = ["🥋", "⛷", "🤺", "🤽🏼‍♂️", "🎳", "🏌🏾", "⛹🏻", "🥌", "🛹", "🏸", "🏐", "🤸🏼‍♀️"]
  
  @State var emojis: [String]
  @State var emojiCount: Int
  
  init(viewModel: EmojiMemoryGame) {
    self.viewModel = viewModel
    emojis = vehicles.shuffled()
    emojiCount = Int.random(in: 4..<vehicles.count)
  }
  
  var body: some View {
    VStack {
      Text("Memorize!")
        .font(.largeTitle)
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
      .foregroundColor(.red)
      
      Spacer()
      HStack(alignment: .bottom) {
        Spacer()
        ThemeChooserButton(title: "Vehicles", icon: "car.2", view: self, keyPath: \.vehicles)
        Spacer()
        ThemeChooserButton(title: "Animals", icon: "hare", view: self, keyPath: \.animals)
        Spacer()
        ThemeChooserButton(title: "Sports", icon: "sportscourt", view: self, keyPath: \.sports)
        Spacer()
      }
      .font(.largeTitle)
      .padding(.horizontal)
    }
    .padding(.horizontal)
  }
}

struct CardView: View {
  let card: MemoryGame<String>.Card
  
  var body: some View {
    ZStack {
      let shape = RoundedRectangle(cornerRadius: 20)
      if card.isFaceUp {
        shape.fill().foregroundColor(.white)
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

struct ThemeChooserButton: View {
  var title: String
  var icon: String
  var view: ContentView
  var keyPath: KeyPath<ContentView, Array<String>>
  
  var body: some View {
    Button {
      view.emojiCount = Int.random(in: 4..<view[keyPath: keyPath].count)
      view.emojis = view[keyPath: keyPath].shuffled()
    } label: {
      VStack {
        Image(systemName: icon)
        Text(title)
          .font(.subheadline)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    
    ContentView(viewModel: game)
      .preferredColorScheme(.dark)
    ContentView(viewModel: game)
      .previewDevice("iPhone 11")
      .preferredColorScheme(.light)
    ContentView(viewModel: game)
      .previewDevice("iPhone 13 Pro Max")
  }
}
