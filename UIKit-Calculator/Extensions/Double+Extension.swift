//
//  Double+Extension.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

extension Double {
  /// Returns length of the number.
  var length: Int { String(self).count - 1 }

  /// Returns `true` if number is negative.
  var isNegative: Bool { self < 0 }

  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func getLengthOfIntegerPart() -> Int {
    let absoluteDouble = abs(self).rounded(.down)
    let integerPart = absoluteDouble.truncatingRemainder(dividingBy: 1) == 0
      ? String(format: "%.0f", absoluteDouble)
      : String(absoluteDouble)
    return integerPart.count
  }
}
