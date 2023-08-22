//
//  CoreDelegate.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

protocol CoreDelegate: AnyObject {
  /// <#Description#>
  ///
  /// - Parameter value: <#value description#>
  func getEvaluated(value: Double)

  /// <#Description#>
  ///
  /// - Parameter value: <#value description#>
  func getReplaceable(value: Double)
}
