//
//  Theme.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import Foundation

struct Theme {
  var name: String
  var emojis: [String]
  var numberOfPairsOfCardsToShow: Int
  var color: String
}

extension Theme {
  static let all: [Theme] = [.vehicles, .animals, .sports, .food, .countries, .devices, .instruments]
  
  static let vehicles = Theme(
    name: "Vehicles",
    emojis: ["🚲", "🚂", "🚁", "🚜", "🚕", "🏎", "🚑", "🚓", "🚒", "✈️", "🚀", "⛵️", "🛸", "🛶", "🚌", "🏍", "🛺", "🚠", "🛵", "🚗", "🚚", "🚇", "🛻", "🚝"],
    numberOfPairsOfCardsToShow: 10,
    color: "red"
  )
  
  static let animals = Theme(
    name: "Animals",
    emojis: ["🦧", "🦏", "🐏", "🐈", "🦤", "🦫", "🦥", "🐫", "🐢", "🦭", "🦘", "🐇"],
    numberOfPairsOfCardsToShow: 12,
    color: "yellow"
  )
  
  static let sports = Theme(
    name: "Sports",
    emojis: ["🥋", "⛷", "🤺", "🤽🏼‍♂️", "🎳", "🏌🏾", "⛹🏻", "🥌", "🛹", "🏸", "🏐", "🤸🏼‍♀️"],
    numberOfPairsOfCardsToShow: 5,
    color: "blu"
  )
  
  static let food = Theme(
    name: "Food",
    emojis: ["🧀", "🧄", "🥦", "🍕", "🥗", "🍳", "🍲", "🍱"],
    numberOfPairsOfCardsToShow: 7,
    color: "gray"
  )
  
  static let countries = Theme(
    name: "Countries",
    emojis: ["🇧🇷", "🇮🇹", "🇫🇷", "🇫🇮", "🇬🇷", "🇯🇵", "🇰🇷", "🇷🇺", "🇪🇸", "🇬🇧", "🇺🇦", "🇺🇸", "🇦🇷"],
    numberOfPairsOfCardsToShow: 50,
    color: "gradient"
  )
  
  static let devices = Theme(
    name: "Devices",
    emojis: ["⌚️", "💻", "🎧", "🎮", "🕹", "📟"],
    numberOfPairsOfCardsToShow: 6,
    color: "green"
  )
  
  static let instruments = Theme(
    name: "Instruments",
    emojis: ["🪚", "🔧", "🪛", "🪓", "🔪", "🪄"],
    numberOfPairsOfCardsToShow: 6,
    color: "orange"
  )
}
