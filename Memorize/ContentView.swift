//
//  ContentView.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

struct ContentView: View {
  let vehicles = ["🚲", "🚂", "🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"]
  
  let animals = ["🦧", "🦏", "🐏", "🐈", "🦤", "🦫", "🦥", "🐫", "🐢", "🦭", "🦘", "🐇"]
  
  let sports = ["🥋", "⛷", "🤺", "🤽🏼‍♂️", "🎳", "🏌🏾", "⛹🏻", "🥌", "🛹", "🏸", "🏐", "🤸🏼‍♀️"]
  
  @State var emojis: [String]
  @State var emojiCount: Int
  
  init() {
    emojis = vehicles.shuffled()
    emojiCount = Int.random(in: 4..<vehicles.count)
  }
  
  var body: some View {
    VStack {
      Text("Memorize!")
        .font(.largeTitle)
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
          ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
            CardView(content: emoji)
              .aspectRatio(2/3, contentMode: .fit)
          }
        }
      }
      .foregroundColor(.red)
      
      Spacer()
      HStack(alignment: .bottom) {
        //                remove
        //                Spacer()
        //                add
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
  
  var remove: some View {
    Button {
      if emojiCount > 1 {
        emojiCount -= 1
      }
    } label: {
      Image(systemName: "minus.circle")
    }
  }
  
  var add: some View {
    Button{
      if emojiCount < emojis.count {
        emojiCount += 1
      }
    } label: {
      Image(systemName: "plus.circle")
    }
  }
}

struct CardView: View {
  var content: String
  @State var isFaceUp: Bool = true
  
  var body: some View {
    ZStack {
      let shape = RoundedRectangle(cornerRadius: 20)
      if isFaceUp {
        shape.fill().foregroundColor(.white)
        shape.strokeBorder(lineWidth: 3)
        Text(content).font(.largeTitle)
      } else {
        shape.fill()
      }
    }
    .onTapGesture {
      isFaceUp = !isFaceUp
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
    ContentView()
      .preferredColorScheme(.dark)
    ContentView()
      .previewDevice("iPhone 11")
      .preferredColorScheme(.light)
    ContentView()
      .previewDevice("iPhone 13 Pro Max")
  }
}
