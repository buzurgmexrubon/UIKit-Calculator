//
//  ButtonsView.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

import UIKit

class ButtonsView: UIView {
  /// Delegate from ButtonsViewDelegate.
  weak var delegate: ButtonsViewDelegate?

  /// The button that has in touch drag enter event state.
  private var buttonTracked: ButtonView?

  /// Tells this object that one or more new touches occurred in a view or
  /// window.
  override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    subviews.forEach {
      handleSubviewWhen($0,
                        for: .touchesBegan,
                        point: touches.first?.location(in: $0),
                        event: event)
    }
  }

  /// Tells the responder when one or more touches associated with
  /// an event changed.
  override func touchesMoved(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    subviews.forEach {
      handleSubviewWhen($0,
                        for: .touchesMoved,
                        point: touches.first?.location(in: $0),
                        event: event)
    }
  }

  /// Tells the responder when one or more fingers are raised from
  /// a view or window.
  override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    if let oldbutton = buttonTracked {
      setup(button: oldbutton, for: .touchUpInside)
    }
  }
}

private extension ButtonsView {
  /// Touch states.
  enum TouchesType {
    case touchesBegan
    case touchesMoved
//  case touchesEnded
  }

  /// Handle subview.
  ///
  /// - Parameters:
  ///   - subview: The subviews of the view.
  ///   - type: The type of the touch state.
  ///   - point: A point specified in the receiver’s local coordinate system.
  ///   - event: The event that warranted a call to this method.
  ///   If you are calling this method from outside your event-handling code,
  ///   you may specify nil.
  func handleSubviewWhen(
    _ subview: UIView,
    for type: TouchesType,
    point: CGPoint?,
    event: UIEvent?
  ) {
    guard let point else { return }

    if let subview = subview.hitTest(point, with: event),
       let button = subview as? ButtonView
    {
      switch type {
        case .touchesBegan:
          setup(button: button, for: .touchDragEnter)
        case .touchesMoved:
          if let oldbutton = buttonTracked, oldbutton != button {
            setup(button: oldbutton, for: .touchDragExit)
          } else {
            setup(button: button, for: .touchDragExit)
          }
      }
    }
  }

  /// Setup button for `type`.
  ///
  /// - Parameters:
  ///   - button: The button that needs send actions for `type`.
  ///   - type: The type of the touch event.
  func setup(button: ButtonView, for type: UIControl.Event) {
    switch type {
      case .touchDragEnter:
        button.sendActions(for: type)
        buttonTracked = button
      case .touchDragExit:
        button.sendActions(for: type)
        buttonTracked = nil
      case .touchUpInside:
        button.sendActions(for: type)
        delegate?.send(selectedButton: button)
      default: break
    }
  }
}
