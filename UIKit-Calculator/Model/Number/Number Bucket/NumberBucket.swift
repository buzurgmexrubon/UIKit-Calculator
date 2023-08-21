//
//  NumberBucket.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

class NumberBucket<Element> {
  /// Includes evaluated value.
  private var bucket: Element?

  /// Getter and Setter for `bucket`.
  var value: Element? {
    get {
      defer { bucket = nil }
      return bucket
    }
    set {
      bucket = newValue
    }
  }
}
