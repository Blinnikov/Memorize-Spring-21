//
//  Theme.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import Foundation

struct Theme: Codable, Identifiable, Equatable, Hashable {
  var name: String
  var emojis: [String] {
    didSet {
      if emojis.count < numberOfPairsOfCardsToShow {
        numberOfPairsOfCardsToShow = emojis.count
      }
    }
  }
  var numberOfPairsOfCardsToShow: Int
  var rgbaColor: RGBAColor
  var id = UUID()
}

struct RGBAColor: Codable, Equatable, Hashable {
  let red: Double
  let green: Double
  let blue: Double
  let alpha: Double
}
