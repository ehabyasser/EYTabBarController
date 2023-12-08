//
//  EYTabBar.swift
//  EYTabBarController
//
//  Created by Ihab yasser on 07/12/2023.
//

import Foundation
import UIKit
import SnapKit

protocol EYTabBarViewDelegate: AnyObject {
    func didSelectTab(at index: Int)
}

public class EYBarItem{
    public let icon:UIImage?
    public let title:String?
    
    public init(icon: UIImage?, title: String?) {
        self.icon = icon
        self.title = title
    }
}

class EYTabBar: UIView {

    weak var delegate: EYTabBarViewDelegate?
    private var shapeLayer: CALayer?
    public var items: [EYBarItem] {
        didSet{
           // setupUI()
        }
    }
    public var tabBackgroundColor:UIColor{
        didSet{
          //  setupUI()
        }
    }
    public var accentColor:UIColor {
        didSet{
            for (index , _) in itemsViews.enumerated(){
                itemsViews[index].accentColor = accentColor
            }
            selectItem(index: 0)
        }
    }
    public var font:UIFont{
        didSet {
            for (index , _) in itemsViews.enumerated(){
                itemsViews[index].font = font
            }
        }
    }
    
    init(items: [EYBarItem] , tabBackgroundColor:UIColor , accentColor:UIColor , font:UIFont){
        self.items = items
        self.tabBackgroundColor = tabBackgroundColor
        self.accentColor = accentColor
        self.font = font
        super.init(frame: .zero)
        self.setupUI()
    }
    
    //UIFont.systemFont(ofSize: 14, weight: .regular)
    private var itemsViews:[EYTabBarItem] = []

    
    required init?(coder: NSCoder) {
        fatalError("coder not impelmented")
    }

    private func setupUI() {
        for (index , item) in items.enumerated() {
            if index != 2 && items.count == 5{
                let barItem = EYTabBarItem(frame: .zero)
                barItem.item = item
                barItem.font = font
                barItem.accentColor = accentColor
                if index < 2 {
                    barItem.tap = {
                        self.delegate?.didSelectTab(at: index)
                        self.selectItem(index: index)
                    }
                }else{
                    barItem.tap = {
                        self.delegate?.didSelectTab(at: index - 1)
                        self.selectItem(index: index - 1)
                    }
                }
                self.itemsViews.append(barItem)
                self.addSubview(barItem)
            }
            
        }
        self.setupConstraint()
        self.selectItem(index: 0)
    }
    
    private func setupConstraint(){
        
        if let barItem = itemsViews.first {
            barItem.snp.makeConstraints { make in
                make.width.height.equalTo(54)
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
            }
        }
        
        if let barItem = itemsViews.get(at: 1) {
            barItem.snp.makeConstraints { make in
                make.width.height.equalTo(54)
                make.top.bottom.equalToSuperview()
                if let prev = itemsViews.first{
                    make.leading.equalTo(prev.snp.trailing).offset(16)
                }else{
                    make.leading.equalToSuperview().offset(86)
                }
            }
        }
        
        
        if let barItem = itemsViews.get(at: itemsViews.count - 2) {
            barItem.snp.makeConstraints { make in
                make.width.height.equalTo(54)
                make.top.bottom.equalToSuperview()
                if let prev = itemsViews.last{
                    make.trailing.equalTo(prev.snp.leading).offset(-16)
                }else{
                    make.trailing.equalToSuperview().offset(-86)
                }
            }
        }
        
        if let barItem = itemsViews.last {

            barItem.snp.makeConstraints { make in
                make.width.height.equalTo(54)
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview().offset(-16)
            }
        }
        
        
    }
    
    
    func selectItem(index:Int){
        self.resetItems()
        self.itemsViews[index].selectItem()
    }
    
    func resetItems(){
        for (index , _) in itemsViews.enumerated() {
            itemsViews[index].desSelectItem()
        }
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = tabBackgroundColor.cgColor
        shapeLayer.lineWidth = 0.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    func createPath() -> CGPath {
        let height: CGFloat = 22.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 20), y: 0), controlPoint2: CGPoint(x: centerWidth - 20, y: height))
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 20, y: height), controlPoint2: CGPoint(x: (centerWidth + 20), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 20
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }

    func createPathCircle() -> CGPath {
        let radius: CGFloat = 22.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
}


class EYTabBarItem:UIView {
    
    private let icon:UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        return icon
    }()
    
    
    private lazy var titelLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = font
        return lbl
    }()
    
    var font:UIFont = UIFont.systemFont(ofSize: 14, weight: .regular){
        didSet{
            titelLbl.font = font
        }
    }
    var accentColor:UIColor = UIColor(hex: "#3AABD6")
    var item:EYBarItem?{
        didSet {
            guard let item = item else {return}
            icon.image = item.icon
            titelLbl.text = item.title
        }
    }
    
    var tap:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(icon)
        self.addSubview(titelLbl)
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        
        titelLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.icon.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        self.layer.cornerRadius = 6
        self.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer(target: self, action: #selector(itemDidTapped))
        self.addGestureRecognizer(ges)
    }
    
    func selectItem(){
        self.backgroundColor = accentColor
    }
    
    
    func desSelectItem(){
        self.backgroundColor = .clear
    }
    
    @objc private func itemDidTapped(){
        self.tap?()
    }
}
