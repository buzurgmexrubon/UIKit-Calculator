//
//  String+Extension.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

extension String {
  /// Return bool value that self is negative or not.
  ///
  /// - Returns: `true` if self is greater than zero. Otherwise, `false`.
  func isNegativeNumberString() -> Bool {
    guard let number = Double(self) else { return false }
    return number < 0
  }
}
