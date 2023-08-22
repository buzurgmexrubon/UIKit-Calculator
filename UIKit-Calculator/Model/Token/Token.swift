//
//  Token.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

struct Token {
  // MARK: Properties

  /// Token content
  var content: TokenContentType

  /// Returns a Boolean value indicating `extractOperand` doesn't nil.
  var isOperand: Bool { extractOperand != nil }

  /// Returns a Boolean value indicating `extractBinaryOperator` doesn't nil.
  var isBinaryOperator: Bool { extractBinaryOperator != nil }

  // MARK: - Initializer

  init(_ type: TokenContentType) {
    switch type {
      case .operand(let operand):
        content = .operand(operand)
      case .unaryOperator(let unaryOperator):
        content = .unaryOperator(.init(type: unaryOperator.type))
      case .binaryOperator(let binaryOperator):
        content = .binaryOperator(.init(type: binaryOperator.type))
    }
  }

  // MARK: - Extract Section

  /// Extract operand from content if it exists
  var extractOperand: Double? {
    if case TokenContentType.operand(let extract) = content {
      return extract
    } else { return nil }
  }

  /// Extract unary operator from content if it exists
  var extractUnaryOperator: UnaryOperator? {
    if case TokenContentType.unaryOperator(let extract) = content {
      return extract
    } else { return nil }
  }

  /// Extract binary operator from content if it exists
  var extractBinaryOperator: BinaryOperator? {
    if case TokenContentType.binaryOperator(let extract) = content {
      return extract
    } else { return nil }
  }
}
