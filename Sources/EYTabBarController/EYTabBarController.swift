// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
import SnapKit

public protocol EYTabBarDelegate{
    func tabDidSelect(index:Int)
    func tabBtnDidTapped()
}

@available(iOS 13.0, *)
open class EYTabBarController: UIViewController , EYTabBarViewDelegate , UINavigationControllerDelegate {
    
    
    private var viewControllers:[UIViewController] = []
    private var tabBarItems:[EYBarItem] = []{
        didSet{
            tabBar.items = tabBarItems
        }
    }
    
    private var tabsItems:[EYBarItem] = []
    
    public var tabBarBackgroundColor:UIColor = UIColor(hex: "#307893"){
        didSet{
            tabBar.tabBackgroundColor = tabBarBackgroundColor
        }
    }
    public var accentColor:UIColor = UIColor(hex: "#3AABD6"){
        didSet{
            tabBar.accentColor = accentColor
        }
    }
    public var delegate:EYTabBarDelegate?
    public var font:UIFont = UIFont.systemFont(ofSize: 14, weight: .regular){
        didSet{
            tabBar.font = font
        }
    }
    
    private var tabBar:EYTabBar = EYTabBar()
    
    private lazy var addBtn:UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.tintColor = .white
        btn.backgroundColor = accentColor
        return btn
    }()
    
    
    public let contentView:UIView = {
        let view = UIView()
        return view
    }()
    
    public var selectedIndex:Int = 0 {
        didSet{
            if !viewControllers.isEmpty && !tabBarItems.isEmpty {
                self.selectTab(index: selectedIndex)
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    
    open func draw(viewControllers:[UIViewController] , tabBarItems:[EYBarItem]){
        self.viewControllers = viewControllers
        self.tabBarItems = tabBarItems
        tabBar.configure(items: tabBarItems, tabBackgroundColor: tabBarBackgroundColor, accentColor: accentColor, font: font)
        tabBar.layer.cornerRadius = 8
        tabBar.clipsToBounds = true
        self.setupUI()
    }

    
    private func setupUI(){
        if viewControllers.isEmpty {return}
        if viewControllers.count != 5 {
            fatalError("maximum tabs number is 5")
        }
        if tabBarItems.count != viewControllers.count {
            fatalError("tabs count must be simular to viewcontrollers")
        }
        for controller in viewControllers {
            if controller is UINavigationController {
                (controller as? UINavigationController)?.delegate = self
                (controller as? UINavigationController)?.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
        let img = tabBarItems.get(at: 2)?.icon
        self.addBtn.setImage(img, for: .normal)
        view.addSubview(contentView)
        self.view.addSubview(tabBar)
        self.view.addSubview(addBtn)
        let vc = viewControllers.get(at: 0) ?? UIViewController()
        ViewEmbedder.embed(parent: self, container: self.contentView, child: vc, previous: self.children.first)
        tabBar.delegate = self
        tabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(54)
        }
        addBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.tabBar.snp.top).offset(18)
            make.width.height.equalTo(40)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addBtn.tap {
            self.tabBar.resetItems()
            if let delegate = self.delegate {
                delegate.tabBtnDidTapped()
            }else{
                let vc = self.viewControllers.get(at: 2) ?? UIViewController()
                self.view.backgroundColor = vc.view.backgroundColor
                ViewEmbedder.embed(parent: self, container: self.contentView, child: vc, previous: self.children.first)
            }
        }
    }
    
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            if let rootViewController = navigationController.viewControllers.first, viewController != rootViewController {
                self.hideTabBar()
            }
        }
        if navigationController.viewControllers.count == 1 {
            self.showTabBar()
        }
    }
    
    
    private func hideTabBar(){
        UIView.animate(withDuration: 0.5) {
            self.tabBar.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.addBtn.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.tabBar.alpha = 0
            self.addBtn.alpha = 0
        }
        self.view.layoutIfNeeded()
    }
    
   private func showTabBar(){
       
        UIView.animate(withDuration: 0.5) {
            self.tabBar.alpha = 1
            self.addBtn.alpha = 1
            self.tabBar.snp.updateConstraints { make in
                make.height.equalTo(54)
            }
            self.addBtn.snp.updateConstraints { make in
                make.height.equalTo(40)
            }
        }
    }
    
    internal func didSelectTab(at index: Int) {
        if let delegate = self.delegate {
            delegate.tabDidSelect(index: index)
        }else{
            if selectedIndex == index {return}
            self.selectedIndex = index
        }
    }
    
    
   private func selectTab(index:Int){
       
        tabBar.selectItem(index: index)
        switch index {
        case 0:
            ViewEmbedder.embed(parent: self, container: self.contentView, child: viewControllers[index], previous: self.children.first)
            break
        case 1:
            ViewEmbedder.embed(parent: self, container: self.contentView, child: viewControllers[index], previous: self.children.first)
            break
        case 2:
            ViewEmbedder.embed(parent: self, container: self.contentView, child: viewControllers[index + 1], previous: self.children.first)
            break
        case 3:
            ViewEmbedder.embed(parent: self, container: self.contentView, child: viewControllers[index + 1], previous: self.children.first)
            break
        default:
            break
        }
    }
    
}
