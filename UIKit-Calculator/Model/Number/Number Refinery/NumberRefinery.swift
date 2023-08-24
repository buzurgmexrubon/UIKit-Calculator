//
//  CalculatorNumberRefinery.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol NumberRefinery: AnyObject {
  /// Convert received number to formatted number.
  ///
  /// - Parameter number: The string value for formatting.
  /// - Returns: Formatter number from received number.
  func convert(_ number: String) -> String

  /// Making formatted string from `evaluated`.
  ///
  /// - Parameter evaluated: The double value for making formatted string.
  /// - Returns: Fotmatted string value.
  func refine(_ evaluated: Double) -> String
}
