//
//  ProgressNavigationController.swift
//  ProgressNavigationController
//
//  Created by Roman Furman on 11.12.2019.
//  Copyright © 2019 uptech. All rights reserved.
//

import UIKit

final class ProgressNavigationController: UINavigationController {

    private lazy var progressStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5.0
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private lazy var progressStackContainer: UIView = {
        let vw = UIView()
        vw.backgroundColor = .black
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    private let maxProgressElements: Int
    private let progressOffset: Int
    private let selectedElementColor = UIColor.gray
    private let deselectedElementColor = UIColor.darkGray


    /// - Parameter progressOffset: Responsable for including VCs in progress. Available values:
    ///
    ///     1: include root in progress display
    ///
    ///     0: not include root in progress display
    ///
    ///     -1: not include the first 2 VCs (root + the next one)
    ///
    ///     and so on...
    ///
    /// - Parameter progressElements: max count of elements in progress
    /// - Parameter root: root ViewController for UINavigationController
    init(root: UIViewController, progressElements: Int = 4, progressOffset: Int = 0) {
        self.maxProgressElements = progressElements
        self.progressOffset = progressOffset
        super.init(nibName: nil, bundle: nil)
        navigationBar.barStyle = .black
        delegate = self
        setUpViews()
        setUpConstraints()
        // Setup a rootVC
        // Since we cant use a init(rootViewController:)
        // Because it will call a pushViewController(_:animated:) before setUpViews() finished
        // We need to use init(nibName:bundle:) + setViewControllers(_:animated:) + setProgress(with:animated:)
        // To handle a progress manually [rf]
        setViewControllers([root], animated: false)
        displayProgress(progressOffset, animated: false)
    }


    required init?(coder aDecoder: NSCoder) {
        let msg = "\(String(describing: type(of: self))) cannot be used with a nib file."
        fatalError(msg)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }


    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let count = progressCount(for: .push)
        displayProgress(count, animated: animated)
        super.pushViewController(viewController, animated: animated)
    }


    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        let count = progressCount(for: .pop)
        displayProgress(count, animated: animated)
        return vc
    }


    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let count = progressCount(for: .popToRoot)
        displayProgress(count, animated: animated)
        return super.popToRootViewController(animated: animated)
    }


    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard let popVCIndex = viewControllers.firstIndex(of: viewController) else {
            let msg = "\(String(describing: type(of: self))) pop to \(viewController), since it not exist in stack"
            fatalError(msg)
        }
        let count = progressCount(for: .popTo(index: popVCIndex))
        displayProgress(count, animated: animated)
        return super.popToViewController(viewController, animated: animated)
    }


    private enum NavigationAction {
        case pop
        case popToRoot
        case popTo(index: Int)
        case push
        case interactiveTransitionCanceled
    }


    private func progressCount(for action: NavigationAction) -> Int {
        var progress = 0
        switch action {
        case .push: progress = viewControllers.count
        case .pop: progress = viewControllers.count - 1
        case .popToRoot: progress = 0
        case let .popTo(index): progress = index
        case .interactiveTransitionCanceled: progress = viewControllers.count
        }
        progress = progress + progressOffset
        return progress
    }


    private func displayProgress(_ progressElements: Int, animated: Bool) {
        let progressElements = max(progressElements, 0)
        let duration: TimeInterval = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else {
                return
            }
            for index in 0 ..< self.maxProgressElements {
                let color = index <= progressElements - 1 ? self.selectedElementColor : self.deselectedElementColor
                self.progressStack.arrangedSubviews[index].backgroundColor = color
            }
        }
    }


    private func setUpViews() {
        navigationBar.addSubview(progressStackContainer)
            progressStackContainer.addSubview(progressStack)
            (1...maxProgressElements).forEach { _ in
                progressStack.addArrangedSubview(makeProgressElementView())
            }
    }


    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += [
            progressStack.topAnchor.constraint(equalTo: progressStackContainer.topAnchor),
            progressStack.leadingAnchor.constraint(equalTo: progressStackContainer.leadingAnchor),
            progressStack.bottomAnchor.constraint(equalTo: progressStackContainer.bottomAnchor),
            progressStack.trailingAnchor.constraint(equalTo: progressStackContainer.trailingAnchor)
        ]
        constraints += [
            progressStackContainer.heightAnchor.constraint(equalToConstant: 4.0),
            progressStackContainer.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressStackContainer.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressStackContainer.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }


    private func makeProgressElementView() -> UIView {
        let vw = UIView()
        vw.backgroundColor = deselectedElementColor
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }

}



// MARK: - UIGestureRecognizerDelegate

extension ProgressNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}



// MARK: - UINavigationControllerDelegate

extension ProgressNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            coordinator.notifyWhenInteractionChanges { [weak self] context in
                guard let self = self else {
                    return
                }
                if context.isCancelled {
                    let count = self.progressCount(for: .interactiveTransitionCanceled)
                    self.displayProgress(count, animated: animated)
                }
            }
        }
    }

}
