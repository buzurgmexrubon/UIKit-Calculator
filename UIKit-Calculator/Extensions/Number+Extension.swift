//
//  Number+Extension.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol Number {}

extension Number where Self: Comparable {
  /// Check less Than or Equal.
  ///
  /// - Parameter number: The number for compare to self.
  /// - Returns: `true` if self less than or equal to `number`.
  /// Otherwise, `false`.
  func isLessThanOrEqual(to number: Self) -> Bool {
    self <= number
  }
}

extension Int: Number {}
