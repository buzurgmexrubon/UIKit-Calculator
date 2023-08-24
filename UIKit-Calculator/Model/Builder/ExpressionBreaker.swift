//
//  ExpressionBreaker.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 22/08/23.
//

class ExpressionBreaker {
  /// Checking new binary operator token precedence greater than or equal from
  /// old binary operator token.
  ///
  /// - Parameters:
  ///   - firstToken: Old binary operator token.
  ///   - secondToken: New binary operator token.
  /// - Returns: `true` if `firstToken` is greater than or
  /// equal to `secondToken`. Otherwise, `false`.
  func check(_ firstToken: Token, _ secondToken: Token) -> Bool {
    guard let firstOperator = firstToken.extractBinaryOperator,
          let secondOperator = secondToken.extractBinaryOperator
    else { return false }

    return firstOperator.isGreaterThanOrEqual(to: secondOperator)
  }
}
