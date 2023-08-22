//
//  ButtonView.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 21/08/23.
//

import UIKit

@IBDesignable
class ButtonView: UIButton {
  /// `true` if set `on` in stroryboard.
  /// Otherwise, `false`.
  @IBInspectable
  private var isCircle: Bool = false { didSet { handleBasedIsCircle() } }
  
  /// Value for label that represent numbers.
  @IBInspectable
  private var labelValue: String = "" { didSet { setup(labelText: labelValue) } }
  
  /// Color of the label.
  @IBInspectable
  private var labelColor: UIColor = .white { didSet { handleWhenLabelColorIsSet() } }
  
  /// Brightness of the button background color.
  @IBInspectable
  private var brightness: CGFloat = 70
  
  /// Button color when it pressed.
  @IBInspectable
  private var colorWhenPressed: UIColor?
  
  /// `true` if set `on` in stroryboard.
  /// Otherwise, `false`.
  @IBInspectable
  private var isZeroButton: Bool = false { didSet { layoutLabel() }}
  
  /// `true` if button selected.
  /// Otherwise, `false`.
  override var isSelected: Bool { didSet { handleBasedIsSelected() } }
  
  /// Original color of the button.
  private var originalColor: UIColor?
  
  /// Original text color of the button.
  private var originalTextColor: UIColor?
  
  /// Animates changes to views.
  private var animator = UIViewPropertyAnimator()
  
  /// Label that represent numbers.
  private var label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.frame.size.width = UIScreen().bounds.width / 4 - 12
    self.frame.size.height = UIScreen().bounds.width / 4 - 12
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  /// Getter and Setter for `labelValue`.
  var buttonValue: String {
    get {
      labelValue
    }
    set {
      labelValue = newValue
    }
  }
  
  /// Make button deselect.
  func forceToDeselect() {
    isSelected = false
  }
}

private extension ButtonView {
  ///
  func makeAnimatorBasedIsSelected() {
    animator = isSelected ?
      makeAnimator(with: updateWhenIsSelected) :
      makeAnimator(with: updateWhenIsDeselected)
  }
  
  /// Handle button if button is circle.
  func handleBasedIsCircle() {
    if isCircle { setupDefaultCornerRadius() }
  }
  
  /// Handle button if button is selected.
  func handleBasedIsSelected() {
    if animator.isRunning { animation(.stop) }
    updateBasedIsSelected()
  }
  
  /// Handle button and setup color for label.
  func handleWhenLabelColorIsSet() {
    setup(labelColor: labelColor)
    save(textColor: labelColor)
  }
  
  /// Update colors when button is selected.
  func updateWhenIsSelected() {
    setup(labelColor: originalColor)
    setup(backgroundColor: .white)
  }
  
  /// Update colors when button is deselect.
  func updateWhenIsDeselected() {
    setup(labelColor: originalTextColor)
    setup(backgroundColor: originalColor)
  }
  
  /// Update button based is selected.
  func updateBasedIsSelected() {
    makeAnimatorBasedIsSelected()
    animation(.start)
  }
}

// MARK: Animation Section

private extension ButtonView {
  /// State of the animation.
  enum AnimationState {
    case start
    case stop
  }
  
  /// Start and stop animation based on `state`.
  ///
  /// - Parameter state: State of the animation.
  func animation(_ state: AnimationState) {
    switch state {
      case .start: animator.startAnimation()
      case .stop: animator.stopAnimation(true)
    }
  }
}
  
private extension ButtonView {
  /// Setup color of the label.
  ///
  /// - Parameter labelColor: Color of the button label.
  func setup(labelColor: UIColor?) {
    label.textColor = labelColor
  }
  
  /// Setup text of the label.
  ///
  /// - Parameter labelText: Text of the label.
  func setup(labelText: String) {
    label.text = labelText
  }
  
  /// Setup backgorund color.
  ///
  /// - Parameter backgroundColor: Buttons background color.
  func setup(backgroundColor: UIColor?) {
    self.backgroundColor = backgroundColor
  }
  
  /// Setup corner radius.
  func setupDefaultCornerRadius() {
    layer.cornerRadius = frame.height / 2 - 5
  }
  
  /// Save button color. If button selected used saved color.
  func saveBackgroundColor() {
    originalColor = backgroundColor ?? .clear
  }
  
  /// Save color of the text.
  ///
  /// - Parameter textColor: Color of the text.
  func save(textColor: UIColor?) {
    originalTextColor = textColor
  }
  
  /// Make animaotor with entered `animation`.
  ///
  /// - Parameter animation: Function that modify any animatable view properties.
  /// - Returns: Animator based on received `animation`.
  func makeAnimator(with animation: (() -> Void)?) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator(duration: 0.5,
                                  curve: .easeOut,
                                  animations: animation)
  }
}

// MARK: - Setup Methods

private extension ButtonView {
  /// Setup button.
  func setup() {
    tintColor = .clear
    saveBackgroundColor()
    setupInteraction()
    setupLabel()
  }
  
  /// Setup interaction.
  func setupInteraction() {
    addTarget(self,
              action: #selector(touchDown),
              for: [.touchDown, .touchDragEnter])
    addTarget(self,
              action: #selector(touchUp),
              for: [.touchUpInside, .touchDragExit, .touchCancel])
  }
  
  /// Setup label.
  func setupLabel() {
    addSubview(label)
    label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
  }
  
  /// Setup constraints for label.
  func layoutLabel() {
    if isZeroButton {
      NSLayoutConstraint.activate([
        label.centerYAnchor.constraint(equalTo: centerYAnchor),
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
      ])
    } else {
      NSLayoutConstraint.activate([
        label.centerYAnchor.constraint(equalTo: centerYAnchor),
        label.centerXAnchor.constraint(equalTo: centerXAnchor)
      ])
    }
  }
}

// MARK: - Action Methods

private extension ButtonView {
  /// Button interaction method for touch down.
  @objc func touchDown() {
    animation(.stop)
    setup(backgroundColor: colorWhenPressed)
    setup(backgroundColor: colorWhenPressed ?? originalColor?.lighter(by: brightness))
  }
  
  /// Button interaction method for touch up.
  @objc func touchUp() {
    makeAnimatorBasedIsSelected()
    animation(.start)
  }
}
