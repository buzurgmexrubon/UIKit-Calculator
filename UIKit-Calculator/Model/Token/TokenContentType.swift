//
//  TokenType.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

enum TokenContentType {
  case operand(Double)
  case unaryOperator(UnaryOperator)
  case binaryOperator(BinaryOperator)
}

enum TokenType {
  case operand
  case unaryOperator(UnaryOperatorType)
  case binaryOperator(BinaryOperatorType)
}
