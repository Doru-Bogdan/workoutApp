//
//  TabBarViewController.swift
//  QuickTrain-iOS
//


import UIKit
import SnapKit
import RxSwift

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var tabItems: TabItems?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }

    private func setupTabs() {
        if tabItems == nil {
            let bottomSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            
            tabItems = TabItems.loadFromNib()
            view.addSubview(tabItems!)
            tabItems!.snp.makeConstraints { (make) in
                make.trailing.leading.equalToSuperview()
                make.bottom.equalTo(view.safeAreaInsets.bottom).inset(bottomSafeArea)
                make.height.equalTo(50)
            }
            
            let blankView = UIView()
            if #available(iOS 13.0, *) {
                blankView.backgroundColor = UIColor.systemBackground
            }
            view.addSubview(blankView)
            blankView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaInsets.bottom)
                make.height.equalTo(bottomSafeArea)
            }

            tabItems?.didSelectTab.subscribe(onNext: { [unowned self] tabIndex in
                self.selectedIndex = tabIndex
                guard let viewController = self.viewControllers?[tabIndex] else { return }
                
                if let _ = viewController as? UINavigationController {
                    let viewCtrls = self.moreNavigationController.viewControllers
                    guard viewCtrls.count > 1 else { return }
                    self.moreNavigationController.popToViewController(viewCtrls[1], animated: false)
                }
            }).disposed(by: disposeBag)
        }
    }
}

