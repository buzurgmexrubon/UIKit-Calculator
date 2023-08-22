//
//  ButtonsViewDelegate.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol ButtonsViewDelegate: AnyObject {
  /// Send selected button.
  ///
  /// - Parameter button: The button that selected.
  func send(selectedButton button: ButtonView)
}
