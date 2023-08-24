//
//  CalculatorConverter.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

class CalculatorConverter: Converter {
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
  
  /// Remove all elements from `tempBuffer` and `resultBuffer`.
  func clear() {
    tempBuffer.removeAll()
    resultBuffer.removeAll()
  }
  
  /// Handle token that exists in expression.
  ///
  /// - Parameter token: Token for handling.
  private func handle(token: Token) {
    if let newOperator = token.extractBinaryOperator {
      tempBuffer.append(newOperator)
    } else if token.extractOperand != nil {
      resultBuffer.append(token)
    }
  }
}
