//
//  Core.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

class Core {
  /// <#Description#>
  weak var delegate: CoreDelegate?
  
  /// The token factory that create token from String.
  private let factory = TokenFactory()
  
  /// Expression converter.
  private let converter = Converter()
  
  /// Expression evaluator.
  private let evaluator = Evaluator()
  
  /// Building expression.
  private let buildingExpression = Builder<Token>()
  
  /// Includes most recent operand token if it exists.
  private var mostRecentOperandToken: Token?
  
  /// Includes most recent binary operator token if it exists.
  private var mostRecentBinaryOperatorToken: Token?
  
  /// Includes most recent token if it exists.
  private var mostRecentToken: Token?
  
  /// Includes most recent evaluated if it exists.
  private var mostRecentEvaluated: Double?
  
  /// Evaluation state.
  private var isEvaluating = false
  
  /// Includes evaluated binary operator token if it exists.
  private var evaluatedBinaryOperator: Token?
  
  /// Includes evaluated operand token if it exists.
  private var evaluatedOperand: Token?
  
  /// Result of the evaluated expression.
  private var value: Double = 0.0 {
    didSet { delegate?.getEvaluated(value: value) }
  }
  
  /// Receive operand from `operand`.
  ///
  /// - Parameter operand: Received operand.
  func receive(operand: String) {
    let operandToken = makeToken(from: operand)
    
    if isEvaluating {
      if isEqualWithLastEvaluated(operand) {
        buildingExpression.value = [operandToken]
      } else {
        clearRecordedExpression()
        add(operand: operandToken)
      }
    } else {
      add(operand: operandToken)
    }
  }
  
  /// Receive binary operator from `binaryOperator`.
  ///
  /// - Parameter binaryOperator: Received binary operator.
  func receive(binaryOperator: String) {
    let token = makeToken(from: binaryOperator)
    
    if isEvaluating { stopContinuingEvaluation() }
    
    if mostRecentTokenIsBinaryOperator() {
      replaceBinaryOperator(with: token)
      return
    }
    
    add(binaryOperator: token)
  }
  
  /// Received unary operator from `unaryOperator`.
  ///
  /// - Parameter unaryOperator: Received unary operator.
  func receive(unaryOperator: String) {
    guard buildingExpression.count >= 1 else { return }
    
    let token = makeToken(from: unaryOperator)
    
    if let extracted = token.extractUnaryOperator {
      if isIncompleteExpression() {
        let value = extracted.calculate(number: buildingExpression.remove()!.extractOperand!)
        let valueToken = makeToken(from: String(value))
        buildingExpression.value = [valueToken]
        self.value = value
        return
      } else if isUnbalancedExpression() {
        var number = mostRecentOperandToken!.extractOperand!
        number = extracted.calculate(number: number)
        delegate?.getReplaceable(value: number)
      } else {
        var number = mostRecentToken!.extractOperand!
        number = extracted.calculate(number: number)
        delegate?.getReplaceable(value: number)
        buildingExpression.remove()
      }
    }
  }
  
  /// Receive evaluation.
  ///
  /// - Returns: Evaluated value in Double.
  func receiveEvaluation() -> Double? {
    if isEvaluating { prepareContinuingEvaluation() }
    else if isIncompleteExpression() { reset(); return nil }
    
    if isUnbalancedExpression() { makeBalancedExpression() }
    
    return performEvaluation()
  }
  
  // MARK: - `Clear`
  
  /// Receive clear and clear
  func receiveClear() {
    reset()
  }
}

// MARK: Checking Methods

private extension Core {
  /// Return expression is incomplete or not.
  ///
  /// - Returns: `true` if `buildExpression` values count less than or
  /// equal to 1. Otherwise, `false`.
  func isIncompleteExpression() -> Bool {
    buildingExpression.value.count <= 1
  }
  
  /// Return expression is unbalanced or not.
  ///
  /// - Returns: `true` if `mostRecentToken` is an operand. Otherwise, `false`.
  func isUnbalancedExpression() -> Bool {
    mostRecentToken?.extractOperand == nil
  }
  
  /// Returns last evaluated is equal or not to most recent evaluated value.
  ///
  /// - Parameter value: Evaluated value in String.
  /// - Returns: `true` if evaluated value equal to `mostRecentEvaluated`.
  /// Otherwise, `false`.
  func isEqualWithLastEvaluated(_ value: String) -> Bool {
    Double(value)!.isEqual(to: mostRecentEvaluated!)
  }
}

private extension Core {
  /// Perform evaluation.
  ///
  /// - Returns: The evaluated Double value.
  func performEvaluation() -> Double {
    let evaluated = evaluate()
    evaluatedOperand = mostRecentOperandToken
    evaluatedBinaryOperator = mostRecentBinaryOperatorToken
    mostRecentEvaluated = evaluated
    
    setContinuingEvaluation()
    
    return evaluated
  }
  
  /// Set continuing evaluation.
  func setContinuingEvaluation() {
    isEvaluating = true
  }
  
  /// Stop continuing Evaluation.
  func stopContinuingEvaluation() {
    isEvaluating = false
  }
  
  /// Prepare continuing evaluation.
  func prepareContinuingEvaluation() {
    add(operand: evaluatedOperand!)
    add(binaryOperator: evaluatedBinaryOperator!)
  }
  
  /// Make token from `value`.
  ///
  /// - Parameter value: The String value needs to create token.
  /// - Returns: Token that created from `value`.
  func makeToken(from value: String) -> Token {
    factory.create(value)
  }
  
  /// Add token to building expression.
  ///
  /// - Parameter token: The token of the button.
  func add(token: Token) {
    buildingExpression.value = [token]
    mostRecentToken = token
  }
  
  /// Add operand to building expression.
  ///
  /// - Parameter operand: The token of the button.
  func add(operand: Token) {
    add(token: operand)
    mostRecentOperandToken = operand
  }
  
  /// Add binary operator to building expression.
  ///
  /// - Parameter binaryOperator: The token of the button.
  func add(binaryOperator: Token) {
    if buildingExpression.count == 0 {
      let zeroToken = makeToken(from: "0")
      add(operand: zeroToken)
      mostRecentOperandToken = zeroToken
    }
    add(token: binaryOperator)
    mostRecentBinaryOperatorToken = binaryOperator
  }
  
  /// Replace binary operator with received token.
  ///
  /// - Parameter token: The token of the button.
  func replaceBinaryOperator(with token: Token) {
    buildingExpression.remove()
    add(binaryOperator: token)
  }
  
  /// Break expression.
  ///
  func breakExpression() {
    let evaluated = evaluate()
    let token = makeToken(from: String(evaluated))
    buildingExpression.value = [token]
    value = evaluated
  }
  
  /// Make balanced expression.
  func makeBalancedExpression() {
    add(operand: mostRecentOperandToken!)
  }
  
  /// Cheking most recent token is binary operator or not.
  ///
  /// - Returns: `true` if most recent token is not binary operator.
  ///  Otherwise, `false`.
  func mostRecentTokenIsBinaryOperator() -> Bool {
    mostRecentToken?.extractBinaryOperator != nil
  }
  
  /// Clear build expression elements.
  func clearRecordedExpression() {
    buildingExpression.clear()
  }
  
  /// Reset to starting state.
  func reset() {
    clearRecordedExpression()
    mostRecentToken = nil
    mostRecentOperandToken = nil
    mostRecentBinaryOperatorToken = nil
    evaluatedOperand = nil
    evaluatedBinaryOperator = nil
    isEvaluating = false
  }
  
  /// Evaluate expression.
  ///
  /// - Returns: Evaluated Double value.
  func evaluate() -> Double {
    let expression = buildingExpression.build()
    let converted = converter.convert(expression)
    let evaluated = evaluator.evaluate(converted)
    return evaluated
  }
}
