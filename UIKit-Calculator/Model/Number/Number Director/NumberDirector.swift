//
//  CalculatorNumberDirector.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol NumberDirector: AnyObject {
  ///
  var builder: Builder<String> { get }

  /// Receive negative sign (`-`).
  func receiveNegativeSign()

  /// Receive decimal point (`.`).
  func receiveDecimalPoint()

  /// Receive number.
  ///
  /// - Parameter number: Received number.
  func receive(number: String)

  /// Receive buildign operand.
  ///
  /// - Returns: Operand that ready to build.
  func receiveBuildingOperand() -> String

  /// Clear and prepare for starting state.
  func receiveClear()

  /// Receive borrowing operand.
  ///
  /// - Returns: Concatinated `builder` values and negative format if needed.
  func receiveBorrowingOperand() -> String
}
