//
//  UnaryOperator.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

struct UnaryOperator: UnaryOperatorProtocol {
  /// The type of the unary operation
  var type: UnaryOperatorType

  /// Calculate unary operation
  ///
  /// - Parameter number: Double value that needs calculate unary operation
  /// - Returns: Double value after perform unary operation.
  func calculate(number: Double) -> Double {
    switch type {
      case .percent: return number * 0.01
    }
  }
}
