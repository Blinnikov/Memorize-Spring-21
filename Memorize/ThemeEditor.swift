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
  }
  
  var nameSection: some View {
    Section(header: Text("Name")) {
      TextField("Name", text: $theme.name)
    }
  }
  
  var addEmojiSection: some View {
    Section(header: Text("Add Emojis")) {
      Text(theme.emojis.joined(separator: " "))
    }
  }
  
  var removeEmojiSection: some View {
    Section(header: Text("Remove Emojis")) {
      Text(theme.emojis.joined(separator: " "))
    }
  }
  
  var cardsSection: some View {
    Section(header: Text("Different Cards Count")) {
      Stepper("Cards Count", value: $theme.numberOfPairsOfCardsToShow)
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
