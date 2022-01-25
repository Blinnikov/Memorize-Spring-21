//
//  Theme.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import Foundation

struct Theme: Codable, Identifiable, Equatable {
  var name: String
  var emojis: [String]
  var numberOfPairsOfCardsToShow: Int
  var color: String
  var id = UUID()
}
