//
//  ViewController5.swift
//  Example
//
//  Created by Ihab yasser on 08/12/2023.
//

import UIKit
import SnapKit

class ViewController5: UIViewController {

    
    private let footer:UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
    }
    

}
