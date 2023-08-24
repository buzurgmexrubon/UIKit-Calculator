//
//  Evaluator.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol Evaluator: AnyObject {
  /// Evaluate expression and return result.
  ///
  /// - Parameter expression: Collection of tokens for evaluation.
  /// - Returns: Evaluated value in `Double`.
  func evaluate(_ expression: Expression) -> Double
}
