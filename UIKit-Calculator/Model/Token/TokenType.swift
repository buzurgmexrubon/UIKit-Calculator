//
//  TokenType.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

enum TokenType {
  case operand(Double)
  case unaryOperator(UnaryOperator)
  case binaryOperator(BinaryOperator)
}

enum TokenTypeOnly {
  case operand
  case unaryOperator
  case binaryOperator
}
