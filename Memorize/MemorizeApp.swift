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
  
  var body: some Scene {
    WindowGroup {
      ThemeChooser(store: themeStore)
    }
  }
}
