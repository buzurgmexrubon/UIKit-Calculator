//
//  ViewController.swift
//  UIKit-Calculator
//
//  Created by Buzurgmexr Sultonaliyev on 22/08/23.
//

import UIKit

import UIKit

class ViewController: UIViewController {
  /// Display view that represent numbers.
  @IBOutlet var mainDisplay: UILabel!
  
  /// Display view that top view of calculator.
  @IBOutlet var displayView: UIView!
  
  /// Buttons view that bottom view of calcualator.
  @IBOutlet var buttonsView: ButtonsView!
  
  /// Clear button.
  @IBOutlet var clearButton: ButtonView!

  /// Calculator core.
  private var core = Core()
  
  /// Number director.
  private var director = NumberDirector(builder: Builder<String>())
  
  /// Number refinery.
  private var refinery = NumberRefinery(9)
  
  /// Number bucket.
  private var bucket = NumberBucket<String>()
  
  /// Selected button.
  private var selectedButton: ButtonView?

  override func viewDidLoad() {
    buttonsView.delegate = self
    setupCustomGestures()
    super.viewDidLoad()
  }

  /// `AC`- action for clear button.
  ///
  /// - Parameter sender: Clear button.
  @IBAction func actionForClearButton(_ sender: ButtonView) {
    handleClear()
  }

  /// `+/-` - action for negative button.
  ///
  /// - Parameter sender: Negative button.
  @IBAction func actionForNegativeButton(_ sender: ButtonView) {
    handleSign()
  }

  /// `.` - action for decimal button.
  ///
  /// - Parameter sender: Decimal button.
  @IBAction func actionForDecimalButton(_ sender: ButtonView) {
    handleDecimalPoint()
  }

  /// Action for number buttons.
  ///
  /// - Parameter sender: Calculator numbers.
  @IBAction func actionForNumberButton(_ sender: ButtonView) {
    makeButtonDeselect(sender)
    handle(number: sender.buttonValue)
  }

  /// Action for binary operators.
  ///
  /// - Parameter sender: Binary operator.
  @IBAction func actionForBinaryOperatorButton(_ sender: ButtonView) {
    makeButtonDeselect(sender)
    makeButtonSelected(sender)
    handle(binaryOperator: sender.buttonValue)
  }
  
  /// Action for unary operator.
  ///
  /// - Parameter sender: Unary operator.
  @IBAction func actionForUnaryOperatorButton(_ sender: ButtonView) {
    handle(unaryOperator: sender.buttonValue)
  }

  /// Action for equal button.
  ///
  /// - Parameter sender: Equal button.
  @IBAction func actionForEqualButton(_ sender: ButtonView) {
    makeButtonDeselect()
    handleCalculation()
  }

  // MARK: Clear Methods
  
  /// Clear ``mainDisplay`` and prepare for all clear.
  private func shallowClear() {
    director.receiveClear()
    updateOperationView()
    makeAllClearButtonPossible()
  }
  
  /// Clear all and prepare to starting state.
  func deepClear() {
    director.receiveClear()
    pourBucketIfNeeded()
    sendClear()
    makeButtonDeselect()
  }
}

// MARK: Handle Section

private extension ViewController {
  /// Handle clear.
  func handleClear() {
    isCurrentlyEnteredOperand()
      ? shallowClear()
      : deepClear()
  }
  
  /// Handle sign.
  func handleSign() {
    if let poured = pourBucketIfNeeded() {
      let converted = poured.isNegativeNumberString()
        ? String(poured.dropLast())
        : "-\(poured)"
      fillBucket(with: Double(converted)!)
      let expressibleNumber = make(expressibleNumber: Double(converted)!)
      updateOperationView(with: expressibleNumber)
    } else {
      handleNegativeSign()
      updateOperationView()
    }
  }
  
  /// Handle negative sign.
  func handleNegativeSign() {
    director.receiveNegativeSign()
  }
  
  /// Handle decimal point.
  func handleDecimalPoint() {
    pourBucketIfNeeded()
    director.receiveDecimalPoint()
    updateOperationView()
  }
  
  /// Handle number from `number`
  ///
  /// - Parameter number: Received number.
  func handle(number: String) {
    pourBucketIfNeeded()
    director.receive(number: number)
    updateOperationView()
    makeClearButtonPossible()
  }
  
  /// handle binary operator from `binaryOperator`.
  ///
  /// - Parameter binaryOperator: Received binary operator.
  func handle(binaryOperator: String) {
    sendProperOperandBefore()
    send(binaryOperator: binaryOperator)
  }
  
  /// Handle unary operator from `unaryOperator`.
  ///
  /// - Parameter unaryOperator: Received unary operator.
  func handle(unaryOperator: String) {
    sendProperOperandBefore()
    send(unaryOperator: unaryOperator)
  }
  
  /// Handle Calculation
  func handleCalculation() {
    sendProperOperandBefore()
    if let calculatedResult = sendCalculation() {
      updateBasedResult(with: calculatedResult)
    } else { handleFailureOfCalculation() }
  }
  
  /// Handle failure of calculation.
  func handleFailureOfCalculation() {
    mainDisplay.shake()
    director.receiveClear()
    updateOperationView()
  }
}

private extension ViewController {
  /// Returns operand currently entered or not.
  ///
  /// - Returns: `true` if clear button in clear state. Otherwise, `false`.
  func isCurrentlyEnteredOperand() -> Bool {
    clearButton.buttonValue == "C"
  }
}

private extension ViewController {
  /// Make clear button possible
  func makeClearButtonPossible() {
    clearButton.buttonValue = "C"
  }
  
  /// Make all clear button possible
  func makeAllClearButtonPossible() {
    clearButton.buttonValue = "AC"
  }
  
  /// Make expressible number for represent result.
  ///
  /// - Parameter expressibleNumber: Result of the calculation.
  /// - Returns: The string value of the representable result.
  func make(expressibleNumber: Double) -> String {
    refinery.refine(expressibleNumber)
  }
  
  /// Make `newButton` selected.
  ///
  /// - Parameter newButton: The button needs make selected button.
  func makeButtonSelected(_ newButton: ButtonView?) {
    if let newButton {
      newButton.isSelected = true
      selectedButton = newButton
    }
  }
  
  /// Make `newButton` deselect.
  ///
  /// - Parameter newButton: The button needs make deselect.
  func makeButtonDeselect(_ newButton: ButtonView? = nil) {
    if let newButton, newButton == selectedButton { return }
    if let oldButton = selectedButton {
      oldButton.forceToDeselect()
      selectedButton = nil
    }
  }
}

private extension ViewController {
  /// Send clear from core calculator.
  func sendClear() {
    core.receiveClear()
  }
  
  /// Send proper operand before.
  func sendProperOperandBefore() {
    if let poured = pourBucketIfNeeded() {
      send(operand: poured)
    } else {
      let operand = requestOperand()
      if !operand.isEmpty { send(operand: operand) }
    }
  }
  
  /// Send received `operand`.
  ///
  /// - Parameter operand: The operand that needs receive from core calculator.
  func send(operand: String) {
    core.receive(operand: operand)
  }
  
  /// Send received `binaryOperator`.
  ///
  /// - Parameter binaryOperator: The binary operator that needs receive
  /// from core calculator.
  func send(binaryOperator: String) {
    core.receive(binaryOperator: binaryOperator)
  }
  
  /// Send received `unaryOperator`.
  ///
  /// - Parameter unaryOperator: The unary operator that needs receive
  /// from core calculator.
  func send(unaryOperator: String) {
    core.receive(unaryOperator: unaryOperator)
  }
  
  /// Send calculation
  ///
  /// - Returns: Calculated value in optional Double.
  func sendCalculation() -> Double? {
    core.receiveEvaluation()
  }
}

private extension ViewController {
  /// Pout bucket if needed
  ///
  /// - Returns: The string value if bucket has a value. Otherwise, `nil`.
  @discardableResult
  func pourBucketIfNeeded() -> String? {
    return bucket.value
  }
  
  /// Add value to bucket.
  ///
  ///
  /// - Parameter number: The Double value that needs add to bucket.
  func fillBucket(with number: Double) {
    bucket.value = String(number)
  }
}

private extension ViewController {
  /// Request operand.
  ///
  /// - Returns: Received operand from ``NumberDirector``.
  func requestOperand() -> String {
    director.receiveBuildingOperand()
  }
}

private extension ViewController {
  /// Update operation view from received string if it exists.
  ///
  /// - Parameter value: The string value that needs represent
  /// in ``mainDisplay``.
  func updateOperationView(with value: String? = nil) {
    if let newValue = value { mainDisplay.text = newValue }
    else {
      let peaked = director.receiveBorrowingOperand()
      mainDisplay.text = refinery.convert(peaked)
      if let lastOfPeaked = peaked.last, lastOfPeaked == "." {
        mainDisplay.text?.append(".")
      }
    }
  }
  
  /// Update operation view based result.
  ///
  /// - Parameter result: Result of the calculation.
  func updateBasedResult(with result: Double) {
    let expressibleNumber = make(expressibleNumber: result)
    fillBucket(with: result)
    updateOperationView(with: expressibleNumber)
  }
  
  /// Prepares for starting calculation.
  func ready() {
    core.delegate = self
    director.receiveClear()
    updateOperationView()
  }
}

extension ViewController: CoreDelegate {
  /// Evaluated value form received `value`.
  ///
  /// - Parameter value: Evalueted value in Double.
  func getEvaluated(value: Double) {
    let expressibleNumber = make(expressibleNumber: value)
    updateOperationView(with: expressibleNumber)
  }
  
  /// Replaceable value from received `value`.
  ///
  /// - Parameter value: Replaceable value in Double.
  func getReplaceable(value: Double) {
    let expressibleNumber = make(expressibleNumber: value)
    updateOperationView(with: expressibleNumber)
    fillBucket(with: value)
  }
}

private extension ViewController {
  /// Setup custom gestures
  func setupCustomGestures() {
    makeLongPressibleView()
  }
  
  /// Make long pressible gesture recognizer.
  func makeLongPressibleView() {
    let longPress = makeLongPressAction(with: #selector(longPress(_:)))
    displayView.addGestureRecognizer(longPress)
  }
}

// MARK: - Action Methods

private extension ViewController {
  /// Make long press action from received selector.
  ///
  /// - Parameter action: A selector that identifies the method implemented
  /// by the target to handle the gesture recognized by the receiver.
  /// The action selector must conform to the signature described
  /// in the class overview. nil isn’t a valid value.
  /// - Returns: A continuous gesture recognizer that interprets
  /// long-press gestures.
  func makeLongPressAction(with action: Selector?) -> UILongPressGestureRecognizer {
    UILongPressGestureRecognizer(target: self, action: action)
  }

  /// Long press action.
  ///
  /// - Parameter recognizer: gesture recognizer for showing menu from
  /// recognized view.
  @objc func longPress(_ recognizer: UIGestureRecognizer) {
    if let recognizedView = recognizer.view,
       recognizer.state == .began
    {
      mainDisplay.becomeFirstResponder()
      UIMenuController.shared.showMenu(from: recognizedView, rect: mainDisplay.frame)
    }
  }
}

// MARK: - ButtonsViewDelegate

extension ViewController: ButtonsViewDelegate {
  /// Send selected button from received `button`.
  ///
  /// - Parameter button: The button that needs make selected button.
  func send(selectedButton button: ButtonView) {
    if ["+", "−", "÷", "×"].contains(button.buttonValue) {
      selectedButton = button
    }
  }
}
