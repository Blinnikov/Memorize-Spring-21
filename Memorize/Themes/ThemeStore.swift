//
//  ThemeStore.swift
//  Memorize
//
//  Created by Igor Blinnikov on 24.01.2022.
//

import SwiftUI

class ThemeStore: ObservableObject {
  let name: String
  
  @Published var themes = [Theme]() {
    didSet {
      scheduleAutoSave()
//      storeInUserDefaults()
    }
  }
  
  private var autoSaveTimer: Timer?
  private let DefaultThemeColor = Color.red
  private let DefaultEmojis = ["👺", "😵‍💫", "🤤"]
  private let AutoSaveInterval = 1.0
  
  init(named name: String) {
    self.name = name
    restoreFromUserDefaults()
    
    if themes.isEmpty {
      print("using built-in themes")
      insertBuiltInThemes()
    } else {
      print("successfully loaded themes from UserDefaults: \(themes)")
    }
  }
  
  private func insertBuiltInThemes() {
    insertTheme(
      Theme(
        name: "Vehicles",
        emojis: ["🚲", "🚂", "🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"],
        numberOfPairsOfCardsToShow: 10,
        rgbaColor: RGBAColor(color: DefaultThemeColor)
      )
    )
    
    insertTheme(
      Theme(
        name: "Animals",
        emojis: ["🦧", "🦏", "🐏", "🐈", "🦤", "🦫", "🦥", "🐫", "🐢", "🦭", "🦘", "🐇"],
        numberOfPairsOfCardsToShow: 12,
        rgbaColor: RGBAColor(color: .yellow)
      )
    )
    
    insertTheme(
      Theme(
        name: "Sports",
        emojis: ["🥋", "⛷", "🤺", "🤽🏼‍♂️", "🎳", "🏌🏾", "⛹🏻", "🥌", "🛹", "🏸", "🏐", "🤸🏼‍♀️"],
        numberOfPairsOfCardsToShow: 5,
        rgbaColor: RGBAColor(color: .blue)
      )
    )
    
    insertTheme(
      Theme(
        name: "Food",
        emojis: ["🧀", "🧄", "🥦", "🍕", "🥗", "🍳", "🍲", "🍱"],
        numberOfPairsOfCardsToShow: 7,
        rgbaColor: RGBAColor(color: .gray)
      )
    )
    
    insertTheme(
      Theme(
        name: "Countries",
        emojis: ["🇧🇷", "🇮🇹", "🇫🇷", "🇫🇮", "🇬🇷", "🇯🇵", "🇰🇷", "🇷🇺", "🇪🇸", "🇬🇧", "🇺🇦", "🇺🇸", "🇦🇷"],
        numberOfPairsOfCardsToShow: 50,
        rgbaColor: RGBAColor(color: .indigo)
      )
    )
    
    insertTheme(
      Theme(
        name: "Devices",
        emojis: ["⌚️", "💻", "🎧", "🎮", "🕹", "📟"],
        numberOfPairsOfCardsToShow: 6,
        rgbaColor: RGBAColor(color: .green)
      )
    )
    
    insertTheme(
      Theme(
        name: "Instruments",
        emojis: ["🪚", "🔧", "🪛", "🪓", "🔪", "🪄"],
        numberOfPairsOfCardsToShow: 6,
        rgbaColor: RGBAColor(color: .orange)
      )
    )
  }
  
  private func scheduleAutoSave() {
    autoSaveTimer?.invalidate()
    autoSaveTimer = Timer.scheduledTimer(withTimeInterval: AutoSaveInterval, repeats: false) { _ in
      self.storeInUserDefaults()
    }
  }
  
  private var userDefaultsKey: String {
    "ThemeStore:\(name)"
  }
  
  private func storeInUserDefaults() {
    let data = try? JSONEncoder().encode(themes)
    UserDefaults.standard.set(data, forKey: userDefaultsKey)
    
    print("Store themes in UserDefaults")
  }
  
  private func restoreFromUserDefaults() {
    if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
       let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
      themes = decodedThemes
    }
  }
  
  func theme(at index: Int) -> Theme {
    let safeIndex = min(max(index, 0), themes.count - 1)
    return themes[safeIndex]
  }
  
  func insertNewTheme(named name: String = "New") {
    insertTheme(
      Theme(name: name, emojis: DefaultEmojis, numberOfPairsOfCardsToShow: 2, rgbaColor: RGBAColor(color: DefaultThemeColor)),
      at: themes.count
    )
  }
  
  private func insertTheme(_ theme: Theme, at index: Int = 0) {
    let safeIndex = min(max(index, 0), themes.count)
    themes.insert(theme, at: safeIndex)
  }
}
