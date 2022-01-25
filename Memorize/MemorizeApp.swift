//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
  @StateObject var themeStore = ThemeStore(named: "Default")
  private let game = EmojiMemoryGame(with: ThemeStore(named: "Default").theme(at: 2))
  
  var body: some Scene {
    WindowGroup {
      EmojiMemoryGameView(viewModel: game)
        .environmentObject(themeStore)
    }
  }
}
