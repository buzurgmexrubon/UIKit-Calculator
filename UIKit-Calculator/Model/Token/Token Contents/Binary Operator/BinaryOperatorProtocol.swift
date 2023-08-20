//
//  BinaryOperatorProtocol.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

protocol BinaryOperatorProtocol {
  // MARK: Properties
  
  /// The type of the binary operator.
  var type: BinaryOperatorType { get }
  
  /// The associativity of the binary operator.
  var associativity: BinaryOperatorAssociativity { get }
  
  /// The precedence of the binary operator.
  var precedence: BinaryOperatorPrecedence { get }
  
  // MARK: Methods
  
  /// Cheking binary operation associativity.
  ///
  /// - Parameter second: Second binary operator for comparison.
  /// - Returns: Self is higher or not than second binary operator.
  func isHigher(than second: BinaryOperator) -> Bool
  
  /// Cheking binary operation associativity.
  ///
  /// - Parameter second: Second binary operator for comparison.
  /// - Returns: Self is greater than or equal to second binary operator.
  func isGreaterThanOrEqual(to second: BinaryOperator) -> Bool
  
  /// Calculate binary operation.
  ///
  /// - Parameters:
  ///   - first: First operand of binary operation.
  ///   - second: Second operand of binary operation.
  /// - Returns: Calculated value in Double.
  func calculate(_ first: Double, _ second: Double) -> Double
}
