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
        super.viewDidLoad()
        let viewControllers = [UINavigationController(rootViewController: ViewController1()) , ViewController2() , ViewController3() , ViewController4() , ViewController5()]
       let  tabBarItems = [EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house") , EYBarItem(icon: UIImage(systemName: "house"), title: "house")]
        tabBarBackgroundColor = .black
        accentColor = .green
        font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        //delegate = self
        self.draw(viewControllers: viewControllers, tabBarItems: tabBarItems)
    }

    func tabDidSelect(index: Int) {
        print(index)
    }
}

