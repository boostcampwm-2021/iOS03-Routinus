//
//  ManageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class ManageViewController: UIViewController {
    // TODO: 챌린지 추가 화면으로 이동하기 위한 임시 버튼(추후 삭제)
    private lazy var foo = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foo2()
    }
    
    // TODO: 챌린지 추가 화면으로 이동하기 위한 임시 로직(추후 삭제)
    func foo2() {
        view.addSubview(foo)
        foo.setTitle("화면 이동", for: .normal)
        foo.backgroundColor = .white
        foo.setTitleColor(.black, for: .normal)
        foo.addTarget(self, action: #selector(foo3), for: .touchUpInside)
    }
    
    // TODO: 챌린지 추가 화면으로 이동하기 위한 임시 로직(추후 삭제)
    @objc func foo3() {
        let vc = CreateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
