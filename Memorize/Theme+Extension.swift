//
//  Theme+Extension.swift
//  Memorize
//
//  Created by Igor Blinnikov on 29.01.2022.
//

import SwiftUI

extension Theme {
  var color: Color {
    get {
      Color(rgbaColor: self.rgbaColor)
    }
    set {
      self.rgbaColor = RGBAColor(color: newValue)
    }
  }
}
