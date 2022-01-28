//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Igor Blinnikov on 28.01.2022.
//

import SwiftUI

struct ThemeEditor: View {
  @Binding var theme: Theme
  
  var body: some View {
    Form {
      nameSection
      addEmojiSection
      removeEmojiSection
      cardsSection
      colorSection
    }
    .onAppear {
      // Restore background because it's applied globally
      UITableView.appearance().backgroundColor = UIColor.systemGroupedBackground
    }
  }
  
  var nameSection: some View {
    Section(header: Text("Name")) {
      TextField("Name", text: $theme.name)
    }
  }
  
  @State private var emojisToAdd = ""
  
  var addEmojiSection: some View {
    Section(header: Text("Add Emojis")) {
      TextField("", text: $emojisToAdd)
        .onChange(of: emojisToAdd) { emojis in
          withAnimation{
            addEmojis(emojis)
          }
        }
    }
  }
  
  func addEmojis(_ emojis: String) {
    let newEmojis = emojis.filter { $0.isEmoji }.map{ String($0) }
    print(newEmojis)
    for newEmoji in newEmojis {
      if !theme.emojis.contains(newEmoji) {
        theme.emojis.append(newEmoji)
      }
    }
  }
  
  var removeEmojiSection: some View {
    Section(header: Text("Remove Emoji")) {
//      let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
      let emojis = theme.emojis
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
        ForEach(emojis, id: \.self) { emoji in
          Text(emoji)
            .onTapGesture {
              withAnimation {
                guard theme.emojis.count > 2 else { return }
                emojisToAdd = ""
                theme.emojis.removeAll(where: { String($0) == emoji })
              }
            }
        }
      }
      .font(.system(size: 40))
    }
  }
  
  var cardsSection: some View {
    Section(header: Text("Different Cards Count")) {
      Stepper("\(theme.numberOfPairsOfCardsToShow) pairs", value: $theme.numberOfPairsOfCardsToShow, in: 2...theme.emojis.count)
    }
  }
  
  @State var cardColor: Color = Color.red
  
  var colorSection: some View {
    Section(header: Text("Card Color")) {
      ColorPicker("Color", selection: $cardColor)
    }
  }
}

struct ThemeEditor_Previews: PreviewProvider {
  static var previews: some View {
    ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 0)))
  }
}
