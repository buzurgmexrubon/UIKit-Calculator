//
//  BinaryOperatorProtocol.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

protocol CalculatorBinaryOperator {
  // MARK: Properties
  
  /// The type of the binary operator.
  var type: BinaryOperatorType { get }
  
  /// The precedence of the binary operator.
  var precedence: BinaryOperatorPrecedence { get }
  
  // MARK: Methods
  
  /// Returns a Boolean value indicating whether this instance is higher than
  /// the given value.
  ///
  /// - Parameter second: The value to compare with this value.
  /// - Returns: `true` if self precendence is higher than `second` precendence.
  ///  Otherwise, `false`.
  func isHigher(than second: BinaryOperator) -> Bool
  
  /// Returns a Boolean value indicating whether this instance is greater than
  /// or equal to the given value.
  ///
  /// - Parameter second: The value to compare with this value.
  /// - Returns: `true` if self precendence is `second` precendence.
  ///  Otherwise, `false`.
  func isGreaterThanOrEqual(to second: BinaryOperator) -> Bool
  
  /// Calculate binary operation.
  ///
  /// - Parameters:
  ///   - first: First operand of binary operation.
  ///   - second: Second operand of binary operation.
  /// - Returns: Double value after perform binary operation.
  func calculate(_ first: Double, _ second: Double) -> Double
}
