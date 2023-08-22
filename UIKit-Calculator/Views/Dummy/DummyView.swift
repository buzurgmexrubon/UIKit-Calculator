//
//  DummyView.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

import UIKit

class DummyView: UIView {
  /// Returns the farthest descendant of the receiver in the view hierarchy
  /// (including itself) that contains a specified point.
  ///
  /// - Parameters:
  ///   - point: A point specified in the receiver’s local coordinate system.
  ///   - event: The event that warranted a call to this method.
  ///   If you are calling this method from outside your event-handling code,
  ///   you may specify nil.
  override func hitTest(
    _ point: CGPoint,
    with event: UIEvent?
  ) -> UIView? {
    superview
  }
}
