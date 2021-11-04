//
//  DetailViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class DetailViewController: UIViewController {
    
    lazy var cntLabel: UILabel = {
        let label = UILabel()
        label.text = "DetailView"
        
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
        self.setupLayout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
