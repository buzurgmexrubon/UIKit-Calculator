//
//  NumberDirector.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

class NumberDirector: CalculatorNumberDirector {
  // MARK: Properties

  ///
  var builder: Builder<String>

  ///
  private var operand = ""

  ///
  private var isNegativeFormat = false

  ///
  private var isDecimalFormat = false

  ///
  private var isEnteredZeroFromUser = false

  ///
  private var isMaximum: Int {
    builder.value.filter {
      ($0 != Symbols.decimalPoint) && ($0 != Symbols.negative)
    }.count
  }

  // MARK: Initializer

  init(builder: Builder<String>) {
    self.builder = builder
  }

  // MARK: Methods

  /// Receive negative sign (`-`).
  func receiveNegativeSign() {
    isNegativeFormat.toggle()
  }

  /// Receive decimal point (`.`).
  func receiveDecimalPoint() {
    guard isDecimalFormat else { setDecimalFormat(); return }
    if isLastDecimalPoint() { releaseDecimalPoint() }
  }

  /// Receive number.
  ///
  /// - Parameter number: Received number.
  func receive(number: String) {
    guard isMaximum != 9 else { return }

    if number == "0" { isEnteredZeroFromUser = true }

    if isStartingState() { replaceFirstDigit(with: number) }
    else { builder.value = [number] }
  }

  /// Receive buildign operand.
  ///
  /// - Returns: Operand that ready to build.
  func receiveBuildingOperand() -> String {
    defer { prepareStartingState() }

    if prepareSendingOperand() { setNegativeFormatIfNeeded() }

    return operand
  }

  /// Clear and prepare for starting state.
  func receiveClear() {
    prepareStartingState()
  }

  /// Receive borrowing operand.
  ///
  /// - Returns: Concatinated `builder` values and negative format if needed.
  func receiveBorrowingOperand() -> String {
    defer { operand = "" }
    prepareShowingOperand()
    setNegativeFormatIfNeeded()
    return operand
  }
}

private extension NumberDirector {
  /// Set decimal point.
  func setDecimalFormat() {
    isDecimalFormat = true
    builder.value = [Symbols.decimalPoint]
  }

  // Set negative sign if format of the number is negative.
  func setNegativeFormatIfNeeded() {
    if isNegativeFormat { operand = "-" + operand }
  }
}

private extension NumberDirector {
  /// Remove decimal point.
  func releaseDecimalPoint() {
    isDecimalFormat = false
    builder.remove()
  }

  /// Replace first digit to entered number.
  ///
  /// - Parameter number: The number you want to substitute for zero.
  func replaceFirstDigit(with number: String) {
    builder.remove()
    builder.value = [number]
  }

  /// Prepare for starting state.
  func prepareStartingState() {
    builder.clear()
    builder.value = ["0"]

    operand = ""
    isNegativeFormat = false
    isDecimalFormat = false
    isEnteredZeroFromUser = false
  }

  /// Set value to `operand` that concatinated builder value.
  func prepareShowingOperand() {
    operand = builder.value.joined()
  }
}

// MARK: Checking Section

private extension NumberDirector {
  /// Returns last token is decimal or not.
  ///
  /// - Returns: `true` if last element of builder is decimal.
  /// Otherwise, `false`.
  func isLastDecimalPoint() -> Bool {
    guard let last = builder.peak() else { return false }
    return last == Symbols.decimalPoint
  }

  /// Checking calculator in starting point or not.
  ///
  /// - Returns: `true` if calculator in starting point.
  /// Otherwise, `false`.
  func isStartingState() -> Bool {
    builder.count == 1 && builder.peak()! == "0"
  }

  /// Prepare sending operand.
  ///
  /// - Returns: `true` if received operand is zero or
  /// calculator is not on starting state. Otherwise, `false`.
  func prepareSendingOperand() -> Bool {
    if isStartingState() {
      if isEnteredZeroFromUser {
        operand = builder.build().joined()
        return true
      } else { return false }
    } else {
      operand = builder.build().joined()
      return true
    }
  }
}
