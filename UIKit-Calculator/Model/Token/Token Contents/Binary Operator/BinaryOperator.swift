//
//  BinaryOperator.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

struct BinaryOperator: CalculatorBinaryOperator {
  // MARK: Properties
  
  /// The type of the binary operator.
  var type: BinaryOperatorType
  
  /// The associativity of the binary operator.
  var associativity: BinaryOperatorAssociativity
  
  /// The precedence of the binary operator.
  var precedence: BinaryOperatorPrecedence
  
  // MARK: Initiazlizer
  
  init(type: BinaryOperatorType) {
    self.type = type
    self.associativity = type.associativity
    self.precedence = type.precendence
  }
  
  /// Returns a Boolean value indicating whether this instance is higher than
  /// the given value.
  ///
  /// - Parameter second: The value to compare with this value.
  /// - Returns: `true` if self precendence is higher than `second` precendence.
  ///  Otherwise, `false`.
  func isHigher(than second: BinaryOperator) -> Bool {
    self.precedence.rawValue > second.precedence.rawValue
  }
  
  /// Returns a Boolean value indicating whether this instance is greater than
  /// or equal to the given value.
  ///
  /// - Parameter second: The value to compare with this value.
  /// - Returns: `true` if self precendence is greater than or equal to
  /// `second` precendence. Otherwise, `false`.
  func isGreaterThanOrEqual(to second: BinaryOperator) -> Bool {
    self.precedence.rawValue >= second.precedence.rawValue
  }
  
  /// Calculate binary operation.
  ///
  /// - Parameters:
  ///   - first: First operand of binary operation.
  ///   - second: Second operand of binary operation.
  /// - Returns: Double value after perform binary operation.
  func calculate(_ first: Double, _ second: Double) -> Double {
    switch self.type {
      case .add: return first + second
      case .subtract: return first - second
      case .multiply: return first * second
      case .divide: return first / second
    }
  }
}
