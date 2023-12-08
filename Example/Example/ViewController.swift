//
//  ViewController.swift
//  Example
//
//  Created by Ihab yasser on 08/12/2023.
//

import UIKit
import EYTabBarController

class ViewController: EYTabBarController , EYTabBarDelegate{
    

    override func viewDidLoad() {
        viewControllers = [UINavigationController(rootViewController: ViewController1()) , ViewController2() , ViewController3() , ViewController4() , ViewController5()]
        tabBarItems = [EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house")]
        tabBarBackgroundColor = .black
        accentColor = .red
        font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        //delegate = self
        super.viewDidLoad()
        
    }

    func tabDidSelect(index: Int) {
        print(index)
    }
}

