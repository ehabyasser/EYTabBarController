//
//  File.swift
//  
//
//  Created by Ihab yasser on 08/12/2023.
//

import Foundation
import UIKit

extension Collection {
    func get(at index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}


extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}


extension UIButton {
    
    public func tap(callback: @escaping () -> Void) {
        self.endEditing(true)
        addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        if let hashValue = UnsafeRawPointer(bitPattern: "callback".hashValue) {
            objc_setAssociatedObject(self, hashValue, callback, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if let hashValue = UnsafeRawPointer(bitPattern: "callback".hashValue) {
            if let callback = objc_getAssociatedObject(self, hashValue) as? () -> Void {
                callback()
            }
        }
    }
    
    func dropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}


extension UIColor{
    
   public convenience init(hex: String, alpha: CGFloat = 1.0) {
           var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
           hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

           var rgb: UInt64 = 0

           Scanner(string: hexSanitized).scanHexInt64(&rgb)

           let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
           let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
           let blue = CGFloat(rgb & 0x0000FF) / 255.0

           self.init(red: red, green: green, blue: blue, alpha: alpha)
       }

  public static func adaptive(dark: UIColor, light: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        } else {
            return light
        }
    }
    
}
