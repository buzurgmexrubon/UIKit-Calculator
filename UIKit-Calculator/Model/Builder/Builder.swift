//
//  Builder.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 20/08/23.
//

class Builder<Element> {
  // MARK: Properties

  /// The array of the `Element` for store values.
  private var elements: [Element] = []

  /// The array of the `Element` for getting and setting value.
  var value: [Element] {
    get { elements }
    set { elements.append(newValue[0]) }
  }

  /// Count elements of the `elements`.
  var count: Int { elements.count }

  // MARK: - Methods

  /// Removes the last element of the `elements`.
  ///
  /// - Returns: no return value.
  @discardableResult
  func remove() -> Element? {
    elements.popLast()
  }

  /// Get last value of the `elements`.
  ///
  /// - Returns: The last element of the `elements`.
  func peak() -> Element? {
    elements.last
  }

  /// Build expression.
  ///
  /// - Returns: Array of the `Element`.
  func build() -> [Element] {
    defer { clear() }
    return elements
  }

  /// Remove all elements of the `elements`.
  func clear() {
    elements.removeAll()
  }

  /// Insert element to `elements`.
  ///
  /// - Parameters:
  ///   - element: The new element to insert into the array.
  ///   - index: The position at which to insert `element`.
//  func insert(_ element: Element, at index: Int) {
//    guard index < elements.count else { return }
//    if count == 0 {
//      elements.append(element)
//    } else {
//      elements.insert(element, at: index)
//    }
//  }
}
