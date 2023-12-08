//
//  ViewController1.swift
//  Example
//
//  Created by Ihab yasser on 08/12/2023.
//

import UIKit
import SnapKit

class ViewController1: UIViewController {
    
    private let btn:UIButton = {
        let btn = UIButton()
        btn.setTitle("navigate", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(navigate), for: .touchUpInside)
    }
    
    @objc func navigate(){
        let vc = ViewController5()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
