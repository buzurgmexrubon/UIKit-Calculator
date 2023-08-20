//
//  BinaryOperator.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

struct BinaryOperator: BinaryOperatorProtocol {
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
  
  /// Cheking binary operation associativity.
  ///
  /// - Parameter second: Second binary operator for comparison.
  /// - Returns: Self is higher or not than second binary operator.
  func isHigher(than second: BinaryOperator) -> Bool {
    self.precedence.rawValue > second.precedence.rawValue
  }
  
  /// Cheking binary operation associativity.
  ///
  /// - Parameter second: Second binary operator for comparison.
  /// - Returns: Self is greater than or equal to second binary operator.
  func isGreaterThanOrEqual(to second: BinaryOperator) -> Bool {
    self.precedence.rawValue >= second.precedence.rawValue
  }
  
  /// Calculate binary operation.
  ///
  /// - Parameters:
  ///   - first: First operand of binary operation.
  ///   - second: Second operand of binary operation.
  /// - Returns: Calculated value in Double.
  func calculate(_ first: Double, _ second: Double) -> Double {
    switch self.type {
      case .add: return first + second
      case .subtract: return first - second
      case .multiply: return first * second
      case .divide: return first / second
    }
  }
}
