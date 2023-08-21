//
//  Converter.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

class Converter: CalculatorConverter {
  /// Collection of binary operators that prepare for `resultBuffer`.
  var tempBuffer: [BinaryOperator] = []
  
  /// Collection of tokens that prepare for evaluation.
  var resultBuffer: Expression = []
  
  /// Convert collection of tokens to evaluation.
  ///
  /// - Parameter expression: Collection of tokens for converting.
  /// - Returns: Collection of tokens for evaluation.
  func convert(_ expression: Expression) -> Expression {
    defer { clear() }
    
    expression.forEach(handle(token:))
    
    tempBuffer.reversed().forEach {
      resultBuffer.append(Token(.binaryOperator(BinaryOperator(type: $0.type))))
    }
    
    return resultBuffer
  }
  
  /// Clear `tempBuffer` and `resultBuffer`.
  func clear() {
    tempBuffer.removeAll()
    resultBuffer.removeAll()
  }
  
  /// Handle token that exists in expression.
  ///
  /// - Parameter token: Token for handling.
  private func handle(token: Token) {
    if let newOperator = token.extractBinaryOperator {
      for recentOperator in tempBuffer.reversed() {
        if check(newOperator: newOperator, recentOperator: recentOperator) {
          let removed = tempBuffer.removeLast()
          resultBuffer.append(Token(.binaryOperator(.init(type: removed.type))))
        } else { break }
      }
      tempBuffer.append(newOperator)
    } else if token.extractOperand != nil {
      resultBuffer.append(token)
    }
  }
}

private extension Converter {
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - newOperator: <#newOperator description#>
  ///   - recentOperator: <#recentOperator description#>
  /// - Returns: <#description#>
  func check(newOperator: BinaryOperator, recentOperator: BinaryOperator) -> Bool {
    return (newOperator.associativity == .left
      && newOperator.precedence.rawValue <= recentOperator.precedence.rawValue)
      ||
      (newOperator.associativity == .right
        && newOperator.precedence.rawValue < recentOperator.precedence.rawValue)
  }
}
