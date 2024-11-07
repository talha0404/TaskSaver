//
//  BottomSheetViewController.swift
//  Homework
//
//  Created by talha.sahin on 5.09.2024.
//

import UIKit

class BottomSheetViewController: UIViewController {

    weak var delegate: BottomSheetDelegate?

    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var startingPoint: CGPoint = .zero

    // Add UITextField and UIButton
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter data"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add your subviews (e.g., a table view or stack view)
        setupViews()

        // Add pan gesture recognizer
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)

        // Observe keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observers when the view is disappearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupViews() {
        // Configure view appearance
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true

        // Add the textField and button to the view
        view.addSubview(textField)
        view.addSubview(submitButton)

        // Set constraints
        textField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func submitButtonTapped() {
        // Get the text from the textField and pass it to the delegate
        guard let text = textField.text, !text.isEmpty else {
            print("Text field is empty")
            return
        }
        delegate?.didSubmitData(data: text)
        dismiss(animated: true, completion: nil)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view.superview)
        let velocity = gesture.velocity(in: view.superview)

        if translation.y < 0 { return }

        switch gesture.state {
        case .began:
            startingPoint = view.frame.origin
        case .changed:
            let newY = startingPoint.y + translation.y
            if newY >= 0 && newY <= (view.superview?.bounds.height ?? 0) {
                view.frame.origin.y = newY
            }
        case .ended:
            let threshold: CGFloat = 150
            if velocity.y > 500 || view.frame.origin.y > threshold {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = self.view.superview?.bounds.height ?? 0 - self.view.frame.height
                }
            }
        default:
            break
        }
    }

    // MARK: - Keyboard Handling

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        // Get the keyboard's frame
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight = keyboardFrame.height

        // Get the animation duration from the notification
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        // Calculate the distance between the bottom sheet and the bottom of the screen
        let bottomInset = view.superview?.frame.height ?? 0 - view.frame.maxY

        if bottomInset < keyboardHeight {
            // Move the bottom sheet up by the necessary amount to stay above the keyboard
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y -= keyboardHeight - bottomInset
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Get the animation duration from the notification
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        // Restore the bottom sheet's original position when the keyboard is dismissed
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = self.view.superview?.bounds.height ?? 0 - self.view.frame.height
        }
    }
}

class BottomSheetPresentationController: UIPresentationController {
    private let dimmingView = UIView()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        // Configure dimming view
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        dimmingView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissBottomSheet() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        // Set the size of the bottom sheet to be a portion of the screen height
        let height: CGFloat = containerView.bounds.height * 0.5
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.frame = containerView.bounds

        // Animate dimming view appearance
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        // Animate dimming view disappearance
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentAnimation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetDismissAnimation()
    }
}


class BottomSheetPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!)
        toView.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.frame = finalFrame
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

class BottomSheetDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let finalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = finalFrame
        }) { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

protocol BottomSheetDelegate: AnyObject {
    func didSubmitData(data: String)
}
