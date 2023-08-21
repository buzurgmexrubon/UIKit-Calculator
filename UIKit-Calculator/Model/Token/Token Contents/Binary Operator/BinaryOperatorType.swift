//
//  BinaryOperatorType.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

enum BinaryOperatorType: String {
  /// An operator that add two operands.
  case add = "+"

  /// An operator that subtract two operands.
  case subtract = "-"

  /// An operator that multiply two operands.
  case multiply = "×"

  /// An operator that divide two operands.
  case divide = "÷"

//  case exponent = "^"

  /// The precedence of the binary operator.
  var precendence: BinaryOperatorPrecedence {
    switch self {
      case .add, .subtract: return .low
      case .multiply, .divide: return .middle
//      case .exponent: return .high
    }
  }

  /// The associativity of the binary operator.
  var associativity: BinaryOperatorAssociativity {
    switch self {
      case .add, .subtract, .multiply, .divide: return .left
//      case .exponent: return .right
    }
  }
}