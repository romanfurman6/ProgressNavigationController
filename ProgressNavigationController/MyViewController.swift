//
//  MyViewController.swift
//  ProgressNavigationController
//
//  Created by Roman Furman on 11.12.2019.
//  Copyright © 2019 uptech. All rights reserved.
//

import UIKit




class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // swiftlint:disable:next function_body_length
    func setupUI() {

        let pushButton = UIButton()
        pushButton.layer.borderColor = UIColor.darkGray.cgColor
        pushButton.layer.borderWidth = 1.0
        pushButton.setTitleColor(.black, for: .normal)
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        pushButton.setTitle("Push", for: .normal)
        pushButton.addTarget(self, action: #selector(push), for: .touchUpInside)
        pushButton.backgroundColor = .lightGray

        let popButton = UIButton()
        popButton.layer.borderColor = UIColor.darkGray.cgColor
        popButton.layer.borderWidth = 1.0
        popButton.setTitleColor(.black, for: .normal)
        popButton.translatesAutoresizingMaskIntoConstraints = false
        popButton.setTitle("Pop", for: .normal)
        popButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        popButton.backgroundColor = .lightGray

        let popToRootButton = UIButton()
        popToRootButton.layer.borderColor = UIColor.darkGray.cgColor
        popToRootButton.layer.borderWidth = 1.0
        popToRootButton.setTitleColor(.black, for: .normal)
        popToRootButton.translatesAutoresizingMaskIntoConstraints = false
        popToRootButton.setTitle("PopToRoot", for: .normal)
        popToRootButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        popToRootButton.backgroundColor = .lightGray

        let popToSecondButton = UIButton()
        popToSecondButton.layer.borderColor = UIColor.darkGray.cgColor
        popToSecondButton.layer.borderWidth = 1.0
        popToSecondButton.setTitleColor(.black, for: .normal)
        popToSecondButton.translatesAutoresizingMaskIntoConstraints = false
        popToSecondButton.setTitle("PopToSecond", for: .normal)
        popToSecondButton.addTarget(self, action: #selector(popToSecond), for: .touchUpInside)
        popToSecondButton.backgroundColor = .lightGray

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -1.0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.backgroundColor = .black
        let height: CGFloat = 70
        let width: CGFloat = 200
        NSLayoutConstraint.activate([
            pushButton.heightAnchor.constraint(equalToConstant: height),
            pushButton.widthAnchor.constraint(equalToConstant: width),
            popButton.heightAnchor.constraint(equalToConstant: height),
            popButton.widthAnchor.constraint(equalToConstant: width),
            popToRootButton.heightAnchor.constraint(equalToConstant: height),
            popToRootButton.widthAnchor.constraint(equalToConstant: width),
            popToSecondButton.heightAnchor.constraint(equalToConstant: height),
            popToSecondButton.widthAnchor.constraint(equalToConstant: width)
        ])

        [pushButton, popButton, popToRootButton, popToSecondButton].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc
    func push() {
        let vc = MyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func pop() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc
    func popToSecond() {
        guard
            let navigationController = navigationController,
            !navigationController.viewControllers.isEmpty
        else { return }
        let secondVC = navigationController.viewControllers[1]
        navigationController.popToViewController(secondVC, animated: true)
    }

}

