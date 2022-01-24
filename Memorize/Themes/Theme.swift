//
//  Theme.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import Foundation

struct Theme: Codable {
  var name: String
  var emojis: [String]
  var numberOfPairsOfCardsToShow: Int
  var color: String
}
