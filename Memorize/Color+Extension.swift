//
//  Color+Extension.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import SwiftUI

extension Color {
  static func fromString(_ description: String) -> (Color, LinearGradient?) {
    switch description {
    case "red":
      return (.red, nil)
    case "orange":
      return (.orange, nil)
    case "yellow":
      return (.yellow, nil)
    case "blue", "blu":
      return (.blue, nil)
    case "green":
      return (.green, nil)
    case "gradient":
      return (.red, LinearGradient(colors: [.red, .blue], startPoint: .leading, endPoint: .trailing))
    case "brown":
      if #available(iOS 15.0, *) {
        return (.brown, nil)
      } else {
        // Fallback on earlier versions
        fallthrough
      }
    default:
      return (.pink, nil)
    }
  }
}
