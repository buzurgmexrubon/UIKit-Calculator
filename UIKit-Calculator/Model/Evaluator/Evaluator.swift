//
//  Evaluator.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

class Evaluator: CalculatorEvaluator {
  /// Includes operands and evaluated values.
  var stack: [Double] = []

  /// Evaluate expression and return result.
  ///
  /// - Parameter expression: Collection of tokens for evaluation.
  /// - Returns: Evaluated value in `Double`.
  func evaluate(_ expression: Expression) -> Double {
    defer { stack.removeAll() }

    expression.forEach { token in
      if let operand = token.extractOperand {
        stack.append(operand)
      } else if let `operator` = token.extractBinaryOperator {
        let second = stack.removeLast()
        let first = stack.removeLast()
        stack.append(`operator`.calculate(first, second))
      }
    }
    return stack.first!
  }
}
