//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Igor Blinnikov on 26.01.2022.
//

import SwiftUI

struct ThemeChooser: View {
  @ObservedObject var store: ThemeStore
  
  @State var themedViewModels = [UUID: EmojiMemoryGame]()
  
  init(store: ThemeStore) {
    // To make background behind the list white
    UITableView.appearance().backgroundColor = .clear // or .white
    
    // Other possible options for customization are:
    // UINavigationBar.appearance().backgroundColor = .orange
    // UINavigationBar.appearance().tintColor = .green
    // UINavigationBar.appearance().barTintColor = .yellow
    // UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
    // UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.red]
    
    self.store = store
  }
  
  
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
              ListItem(theme: theme)
            }
          }
        }
        .onDelete { indexSet in
          store.themes.remove(atOffsets: indexSet)
        }
        .onMove { indexSet, newOffset in
          store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
        }
      }
      .navigationTitle("Themes")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem { EditButton() }
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Add") {
            store.insertNewTheme()
          }
        }
      }
      .listStyle(GroupedListStyle())
    }
    .onChange(of: store.themes) { _ in
      themedViewModels = mapThemesToDictionary()
    }
    .onAppear {
      themedViewModels = mapThemesToDictionary()
    }
  }
}

struct ListItem: View {
  var theme: Theme
  
  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 8)
        .foregroundColor(Color.fromString(theme.color).0)
        .frame(width: 40, height: 40)
      
      VStack(alignment: .leading) {
        Text(theme.name)
          .font(.title2)
        Text("\(theme.numberOfPairsOfCardsToShow * 2) cards")
          .font(.caption)
          .foregroundColor(.gray)
        Spacer()
        Text(emojisString)
          .font(.footnote)
      }
    }
  }
  
  private var emojisString: String {
    let emojisToShow = 5
    let maxEmojisCount = theme.emojis.count
    let showDots = maxEmojisCount > emojisToShow
    
    let emojis = theme.emojis.prefix(emojisToShow).joined(separator: " ")
    let suffix = showDots ? " ..." : ""
    
    return "\(emojis)\(suffix)"
  }
  
}

struct ThemeChooser_Previews: PreviewProvider {
  static var previews: some View {
    ThemeChooser(store: ThemeStore(named: "Preview"))
  }
}
