//
//  Converter.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

protocol Converter: AnyObject {
  /// Convert collection of tokens to evaluation.
  ///
  /// - Parameter expression: Collection of tokens for converting.
  /// - Returns: Collection of tokens for evaluation.
  func convert(_ expression: Expression) -> Expression
}
