//
//  NumberRefinery.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

import Foundation

class CalculatorNumberRefinery: NumberRefinery {
  /// The maximum length of number that represent in display.
  private let maxLength: Int

  // MARK: Initializer

  init(maxLength: Int) {
    self.maxLength = maxLength
  }

  /// Convert received number to formatted number.
  ///
  /// - Parameter number: The string value for formatting.
  /// - Returns: Formatter number from received number.
  func convert(_ number: String) -> String {
    let numberInDouble = Double(number)!
    let lengths = getEachLengthOf(number: number)
    return converter(lengths.fraction).string(from: NSNumber(value: numberInDouble))!
  }

  /// Making formatted string from `evaluated`.
  ///
  /// - Parameter evaluated: The double value for making formatted string.
  /// - Returns: Fotmatted string value.
  func refine(_ evaluated: Double) -> String {
    return isPossibleMakingDecimalPoint(evaluated)
      ? makeFormattedString(from: evaluated, for: .decimal)!
      : makeFormattedString(from: evaluated, for: .scientific)!
  }
}

private extension CalculatorNumberRefinery {
  /// Get Each length of number that entered.
  ///
  /// - Parameter number: The number that used for getting length.
  /// - Returns: Typle of the `integerPart` and `fractionPart`
  func getEachLengthOf(number: String) -> (integer: Int, fraction: Int) {
    let numberInDouble = Double(number)!
    let integerPart = numberInDouble.getLengthOfIntegerPart()
    var fractionPart = number.count - integerPart - Symbols.decimalPoint.count

    if numberInDouble.isNegative { fractionPart -= Symbols.negative.count }

    return (integerPart, fractionPart)
  }

  /// Returns length of received `fraction`.
  ///
  /// - Parameter fraction: The double value to calculate length of fraction.
  /// - Returns: Length of `fraction`.
  func getLengthOf(fraction: Double) -> Int {
    maxLength - fraction.getLengthOfIntegerPart()
  }

  /// Convert number formatter from digit.
  ///
  /// - Parameter digit: The limited value.
  /// - Returns: The formatter that `maximumFractionDigits` and
  /// `minimumFractionDigits` limited with `digit`.
  func converter(_ digit: Int) -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = digit
    formatter.maximumFractionDigits = digit
    return formatter
  }
}

private extension CalculatorNumberRefinery {
  /// Checking number is possible making decimal point.
  ///
  /// - Parameter number: The number to check is possible or not.
  /// - Returns: `true` if possible making decimal point. Otherwise, `false`.
  func isPossibleMakingDecimalPoint(_ number: Double) -> Bool {
    let length = String(abs(number)).count - 1

    if length.isLessThanOrEqual(to: maxLength) { return true }

    if number.getLengthOfIntegerPart().isLessThanOrEqual(to: maxLength) {
      let test = makeFormatter(maxLength - 1, for: .decimal)!.string(from: NSNumber(value: number))!

      if let test = Double(test), test.isZero { return false }
      else { return true }
    }
    return false
  }
}

private extension CalculatorNumberRefinery {
  /// Make formatter used `limit` and `type`.
  ///
  /// - Parameters:
  ///   - limit: The integer value to represent maximumFractionDigits.
  ///   - type: The type of the number formatter.
  /// - Returns: `NumberFormatter` for `type` with `limit`.
  func makeFormatter(_ limit: Int?, for type: NumberFormatter.Style) -> NumberFormatter? {
    let formatter = NumberFormatter()

    switch type {
      case .decimal:
        formatter.numberStyle = type
        if let limit { formatter.maximumFractionDigits = limit }
        return formatter
      case .scientific:
        formatter.numberStyle = type
        if let sharpsCount = limit {
          let sharps = String(repeating: "#", count: sharpsCount)
          formatter.positiveFormat = "0.\(sharps)E0"
        }
        return formatter
      default: return nil
    }
  }

  /// Make formatted string from received number for recevied type.
  ///
  /// - Parameters:
  ///   - number: The Double value that needs to make formatted String.
  ///   - type: The style of the number formatter.
  /// - Returns: Decimal formatted string.
  func makeFormattedString(from number: Double, for type: NumberFormatter.Style) -> String? {
    switch type {
      case .decimal:
        if number.length.isLessThanOrEqual(to: maxLength) {
          return generateFormatter(from: number, limit: maxLength, for: .decimal)!
        } else {
          let limit = getLengthOf(fraction: number)
          return generateFormatter(from: number, limit: limit, for: .decimal)!
        }
      case .scientific:
        let test = makeFormatter(maxLength - 1, for: .decimal)!.string(from: NSNumber(value: number))!

        if let test = Double(test), test.isZero {
          let limit = maxLength - String(number.getLengthOfIntegerPart() - 1).count - 3
          return generateFormatter(from: number, limit: limit, for: .scientific)!
        } else {
          let limit = maxLength - String(number.getLengthOfIntegerPart() - 1).count - 2
          return generateFormatter(from: number, limit: limit, for: .scientific)!
        }
      default: return nil
    }
  }

  /// Generate formatter from received `number` with `limit` for `type`.
  ///
  /// - Parameters:
  ///   - number: The double value for make formatter.
  ///   - limit: The integer value to represent maximumFractionDigits.
  ///   - type: The type of the number formatter.
  /// - Returns: Formatted number in optional string.
  func generateFormatter(from number: Double, limit: Int, for type: NumberFormatter.Style) -> String? {
    switch type {
      case .decimal:
        return makeFormatter(limit, for: type)!.string(from: NSNumber(value: number))!
      case .scientific:
        return makeFormatter(limit, for: type)!.string(from: NSNumber(value: number))!
      default: return nil
    }
  }
}
