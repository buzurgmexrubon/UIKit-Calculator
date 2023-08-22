//
//  UIColor+Extension.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

import UIKit

extension UIColor {
  /// Return lighter UIColor using `percentage`.
  ///
  /// - Parameter percentage: Percentage of the brightness.
  /// - Returns: Lighter UIColor using received percentage.
  func lighter(by percentage: CGFloat = 30.0) -> UIColor {
    self.adjustBrightness(by: abs(percentage))
  }

  /// Return darker UIColor using `percentage`.
  ///
  /// - Parameter percentage: Percentage of the brightness.
  /// - Returns: Darker UIColor using received percentage.
  func darker(by percentage: CGFloat = 30.0) -> UIColor {
    self.adjustBrightness(by: -abs(percentage))
  }

  /// Adjust brightness by percentage.
  ///
  /// - Parameter percentage: Percentage of the brightness.
  /// - Returns: Adjust brightness of color using received percentage.
  func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
    var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0

    if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
      if brightness < 1.0 {
        let newBrightness: CGFloat

        newBrightness = brightness == 0.0
          ? max(min(brightness + percentage / 100, 1.0), 0.0)
          : max(min(brightness + (percentage / 100.0) * brightness, 1.0), 0, 0)

        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
      } else {
        let newSaturation: CGFloat = min(max(saturation - (percentage / 100.0) * saturation, 0.0), 1.0)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
      }
    }
    return self
  }
}
