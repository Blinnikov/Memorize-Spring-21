//
//  Color+Extension.swift
//  Memorize
//
//  Created by Igor Blinnikov on 07.12.2021.
//

import SwiftUI

extension Color {
  static func fromString(_ description: String) -> Color {
    switch description {
    case "red":
      return .red
    case "orange":
      return .orange
    case "yellow":
      return .yellow
    case "blue", "blu":
      return .blue
    case "green":
      return .green
    case "brown":
      if #available(iOS 15.0, *) {
        return .brown
      } else {
        // Fallback on earlier versions
        fallthrough
      }
    default:
      return .black
    }
  }
}
