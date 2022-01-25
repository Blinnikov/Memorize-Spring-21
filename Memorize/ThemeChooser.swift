//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Igor Blinnikov on 26.01.2022.
//

import SwiftUI

struct ThemeChooser: View {
  @EnvironmentObject var store: ThemeStore
  
  @State var themedViewModels = [UUID: EmojiMemoryGame]()
  
  private func mapThemesToDictionary() -> [UUID: EmojiMemoryGame] {
    store.themes.reduce(into: [UUID: EmojiMemoryGame]()) {
      $0[$1.id] = EmojiMemoryGame(with: $1)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(store.themes) { theme in
          if let viewModel = themedViewModels[theme.id] {
            NavigationLink(destination: EmojiMemoryGameView(viewModel: viewModel)) {
              Text(theme.name)
            }
          }
        }
      }
    }
    .onChange(of: store.themes) { _ in
      themedViewModels = mapThemesToDictionary()
    }
    .onAppear {
      themedViewModels = mapThemesToDictionary()
    }
  }
}

struct ThemeChooser_Previews: PreviewProvider {
  static var previews: some View {
    ThemeChooser()
      .environmentObject(ThemeStore(named: "Preview"))
  }
}
