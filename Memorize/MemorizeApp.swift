//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Igor Blinnikov on 03.08.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
  private let game = EmojiMemoryGame()
  
  var body: some Scene {
    WindowGroup {
      EmojiMemoryGameView(viewModel: game)
    }
  }
}
