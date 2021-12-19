//
//  Cardify.swift
//  Memorize
//
//  Created by Igor Blinnikov on 20.12.2021.
//

import SwiftUI

struct Cardify: ViewModifier {
  var isFaceUp: Bool
  var alreadyBeenSeen: Bool
  let gradient: LinearGradient?
  
  func body(content: Content) -> some View {
    ZStack {
      let dot = Circle()
        .size(width: 5, height: 5)
        .fill(Color.blue)
        .opacity(alreadyBeenSeen ? 1 : 0)
      let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
      
      if isFaceUp {
        shape.fill().foregroundColor(.white)
          .overlay(dot)
          .padding()
        shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.blue)
      }
      else {
        if let gradient = gradient {
          shape.fill(gradient)
        } else {
          shape.fill()
        }
      }
      content.opacity(isFaceUp ? 1 : 0)
    }
  }
  
  private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
  }
}

extension View {
  func cardify(isFaceUp: Bool, alreadyBeenSeen: Bool, gradient: LinearGradient?) -> some View {
    self.modifier(Cardify(isFaceUp: isFaceUp, alreadyBeenSeen: alreadyBeenSeen, gradient: gradient))
  }
}
