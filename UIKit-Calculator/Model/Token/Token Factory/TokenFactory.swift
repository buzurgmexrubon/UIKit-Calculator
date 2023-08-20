//
//  TokenFactory.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

struct TokenFactory {
  /// Create token.
  ///
  /// - Parameter value: The string value for creating token content.
  /// - Returns: A Token from `value`.
  func create(_ value: String) -> Token {
    if isOperand(value) {
      return create(token: value, for: .operand)!
    } else if isUnaryOperator(value) {
      return create(token: value, for: .unaryOperator)!
    } else {
      return create(token: value, for: .binaryOperator)!
    }
  }
}

private extension TokenFactory {
  /// Create token.
  ///
  /// - Parameters:
  ///   - token: The token for creating token content.
  ///   - type: The type of the token.
  /// - Returns: A Token from `token` for `type`.
  func create(token: String, for type: TokenTypeOnly) -> Token? {
    switch type {
      case .operand:
        return Token(.operand(Double(token)!))
      case .unaryOperator:
        if token == "%" {
          return Token(.unaryOperator(UnaryOperator(type: .percent)))
        }
        return nil
      case .binaryOperator:
        if token == "+" {
          return Token(.binaryOperator(BinaryOperator(type: .add)))
        } else if token == "−" {
          return Token(.binaryOperator(BinaryOperator(type: .subtract)))
        } else if token == "×" {
          return Token(.binaryOperator(BinaryOperator(type: .multiply)))
        } else if token == "÷" {
          return Token(.binaryOperator(BinaryOperator(type: .divide)))
        }
        return nil
    }
  }
}

// MARK: - Cheking

private extension TokenFactory {
  /// Returns a Boolean value indicating `input` is an unary operator.
  ///
  /// - Parameter input: The value for checking that is an unary operator or not.
  /// - Returns: `true` if `input` is an unary operator. Otherwise, `false`.
  func isUnaryOperator(_ input: String) -> Bool {
    return UnaryOperatorType(rawValue: input) != nil
  }

  /// Returns a Boolean value indicating `input` is an operand.
  ///
  /// - Parameter input: The value for checking that is an operand or not.
  /// - Returns: `true` if `input` is an operand. Otherwise, `false`.
  func isOperand(_ input: String) -> Bool {
    return Double(input) != nil
      ? true
      : false
  }
}
