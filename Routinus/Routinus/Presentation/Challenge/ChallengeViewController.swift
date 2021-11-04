//
//  ChallengeViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class ChallengeViewController: UIViewController {

    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.text = "ChallengeView"
    
        return label
    }()
    
    private func setupLayout() {
        self.view.addSubview(cntLabel)
        self.cntLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cntLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.cntLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupLayout()
    }

}
