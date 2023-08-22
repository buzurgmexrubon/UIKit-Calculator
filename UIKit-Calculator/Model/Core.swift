//
//  Core.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

class Core {
  /// <#Description#>
  weak var delegate: CoreDelegate?
  
  /// <#Description#>
  private let factory = TokenFactory()
  
  /// <#Description#>
  private let converter = Converter()
  
  /// <#Description#>
  private let evaluator = Evaluator()
  
  /// <#Description#>
  private let buildingExpression = Builder<Token>()
  
  /// <#Description#>
  private var mostRecentOperandToken: Token?
  
  /// <#Description#>
  private var mostRecentBinaryOperatorToken: Token?
  
  /// <#Description#>
  private var mostRecentToken: Token?
  
  /// <#Description#>
  private var mostRecentEvaluated: Double?
  
  /// <#Description#>
  private var isEvaluating = false
  
  /// <#Description#>
  private var evaluatedOperator: Token?
  
  /// <#Description#>
  private var evaluatedOperand: Token?
  
  /// <#Description#>
  private var value: Double = 0.0 {
    didSet { delegate?.getEvaluated(value: value) }
  }
  
  /// <#Description#>
  ///
  /// - Parameter operand: <#operand description#>
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
  
  /// <#Description#>
  ///
  /// - Parameter binaryOperator: <#binaryOperator description#>
  func receive(binaryOperator: String) {
    let token = makeToken(from: binaryOperator)
    
    if isEvaluating { stopContinuingEvaluation() }
    
    if mostRecentTokenIsBinaryOperator() {
      replaceBinaryOperator(with: token)
      return
    }
    
    add(binaryOperator: token)
  }
  
  
  /// <#Description#>
  ///
  /// - Parameter unaryOperator: <#unaryOperator description#>
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
  
  
  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func receiveEvaluation() -> Double? {
    if isEvaluating { prepareContinuingEvaluation() }
    else if isIncompleteExpression() { reset(); return nil }
    
    if isUnbalancedExpression() { makeBalancedExpression() }
    
    return performEvaluation()
  }
  
  // MARK: - `Clear`
  
  /// <#Description#>
  func receiveClear() {
    reset()
  }
}

// MARK: Checking Methods

private extension Core {
  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func isIncompleteExpression() -> Bool {
    buildingExpression.value.count <= 1
  }
  
  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func isUnbalancedExpression() -> Bool {
    mostRecentToken?.extractOperand == nil
  }
  
  /// <#Description#>
  ///
  /// - Parameter string: <#string description#>
  /// - Returns: <#description#>
  func isEqualWithLastEvaluated(_ string: String) -> Bool {
    Double(string)!.isEqual(to: mostRecentEvaluated!)
  }
}

private extension Core {
  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func performEvaluation() -> Double {
    let evaluated = evaluate()
    evaluatedOperand = mostRecentOperandToken
    evaluatedOperator = mostRecentBinaryOperatorToken
    mostRecentEvaluated = evaluated
    
    setContinuingEvaluation()
    
    return evaluated
  }
  
  /// <#Description#>
  func setContinuingEvaluation() {
    isEvaluating = true
  }
  
  /// <#Description#>
  func stopContinuingEvaluation() {
    isEvaluating = false
  }
  
  /// <#Description#>
  func prepareContinuingEvaluation() {
    add(operand: evaluatedOperand!)
    add(binaryOperator: evaluatedOperator!)
  }
  
  /// <#Description#>
  ///
  /// - Parameter string: <#string description#>
  /// - Returns: <#description#>
  func makeToken(from string: String) -> Token {
    factory.create(string)
  }
  
  /// <#Description#>
  ///
  /// - Parameter token: <#token description#>
  func add(token: Token) {
    buildingExpression.value = [token]
    mostRecentToken = token
  }
  
  /// <#Description#>
  ///
  /// - Parameter operand: <#operand description#>
  func add(operand: Token) {
    add(token: operand)
    mostRecentOperandToken = operand
  }
  
  /// <#Description#>
  ///
  /// - Parameter binaryOperator: <#binaryOperator description#>
  func add(binaryOperator: Token) {
    if buildingExpression.count == 0 {
      let zeroToken = makeToken(from: "0")
      add(operand: zeroToken)
      mostRecentOperandToken = zeroToken
    }
    add(token: binaryOperator)
    mostRecentBinaryOperatorToken = binaryOperator
  }
  
  /// <#Description#>
  ///
  /// - Parameter token: <#token description#>
  func replaceBinaryOperator(with token: Token) {
    buildingExpression.remove()
    add(binaryOperator: token)
  }
  
  /// <#Description#>
  ///
  func breakExpression() {
    let evaluated = evaluate()
    let token = makeToken(from: String(evaluated))
    buildingExpression.value = [token]
    value = evaluated
  }
  
  /// <#Description#>
  func makeBalancedExpression() {
    add(operand: mostRecentOperandToken!)
  }
  
  /// <#Description#>
  ///
  /// - Returns: <#description#>
  func mostRecentTokenIsBinaryOperator() -> Bool {
    mostRecentToken?.extractBinaryOperator != nil
  }
  
  /// <#Description#>
  func clearRecordedExpression() {
    buildingExpression.clear()
  }
  
  /// <#Description#>
  func reset() {
    clearRecordedExpression()
    mostRecentToken = nil
    mostRecentOperandToken = nil
    mostRecentBinaryOperatorToken = nil
    evaluatedOperand = nil
    evaluatedOperator = nil
    isEvaluating = false
  }
  
  /// <#Description#>
  /// 
  /// - Returns: <#description#>
  func evaluate() -> Double {
    let expression = buildingExpression.build()
    let converted = converter.convert(expression)
    let evaluated = evaluator.evaluate(converted)
    return evaluated
  }
}
