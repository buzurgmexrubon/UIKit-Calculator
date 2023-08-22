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
      return create(token: value, for: .operand)
    } else if isUnaryOperator(value) {
      return create(token: value, for: .unaryOperator(.init(rawValue: value)!))
    } else {
      return create(token: value, for: .binaryOperator(.init(rawValue: value)!))
    }
  }
}

private extension TokenFactory {
  /// Create token using `token` for `type`.
  ///
  /// - Parameters:
  ///   - token: The token for creating token content.
  ///   - type: The type of the token.
  /// - Returns: A Token from `token` for `type`.
  func create(token: String, for type: TokenType) -> Token {
    switch type {
      case .operand:
        return Token(.operand(Double(token)!))
      case .unaryOperator(let unaryOperatorType):
        switch unaryOperatorType {
          case .percent:
            return Token(.unaryOperator(.init(type: .percent)))
        }
      case .binaryOperator(let binaryOperatorType):
        switch binaryOperatorType {
          case .add:
            return Token(.binaryOperator(.init(type: .add)))
          case .subtract:
            return Token(.binaryOperator(.init(type: .subtract)))
          case .multiply:
            return Token(.binaryOperator(.init(type: .multiply)))
          case .divide:
            return Token(.binaryOperator(.init(type: .divide)))
        }
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
