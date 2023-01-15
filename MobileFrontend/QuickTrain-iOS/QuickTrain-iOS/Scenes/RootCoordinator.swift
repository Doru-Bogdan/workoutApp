//
//  RootCoordinator.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 27.01.2021.
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

class RootCoordinator: BaseCoordinator<Void> {
    private var rootViewController: UIViewController!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {

        let tabBar = TabBarViewController()
        tabBar.setViewControllers([
            goToMainScreen(viewController: tabBar),
            goToProfileScreen(viewController: tabBar),
            goToTopTenUsersviewController(viewController: tabBar),
            goToAddWorkoutScreen(viewController: tabBar)
        ], animated: false)

        tabBar.modalPresentationStyle = .overFullScreen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.rootViewController.present(tabBar, animated: true)
        }
        
        return .never()
    }
    
    private func goToMainScreen(viewController: UITabBarController) -> UIViewController {
        let coordinator = HomeViewCoordinator(rootViewController: viewController)
        
        coordinate(to: coordinator).subscribe().disposed(by: disposeBag)
        
        coordinator.viewController.tabBarItem = createTabItem(icon: Images.iconHome)
        
        return UINavigationController(rootViewController: coordinator.viewController)
    }
    
    private func goToProfileScreen(viewController: UITabBarController) -> UINavigationController {
        let coordinator = ProfileCoordinator(rootViewController: viewController)

        coordinate(to: coordinator).subscribe().disposed(by: disposeBag)

        coordinator.viewController.tabBarItem = createTabItem(icon: Images.iconPeople)

        return coordinator.navigationController!
    }
    
    private func goToTopTenUsersviewController(viewController: UITabBarController) -> UINavigationController {
        let coordinator = TopTenUsersCoordinator(rootViewController: viewController)

        coordinate(to: coordinator).subscribe().disposed(by: disposeBag)

        coordinator.viewController.tabBarItem = createTabItem(icon: Images.iconSpeaker)

        return coordinator.navigationController!
    }
    
    private func goToAddWorkoutScreen(viewController: UITabBarController) -> UINavigationController {
        let coordinator = AddWorkoutCoordinator(rootViewController: viewController)

        coordinate(to: coordinator).subscribe().disposed(by: disposeBag)

        coordinator.viewController.tabBarItem = createTabItem(icon: Images.iconSettings)

        return coordinator.navigationController!
    }

    
    private func createTabItem(icon: UIImage) -> UITabBarItem {
        let item = UITabBarItem()
        item.image = icon
        item.title = nil
        item.imageInsets = .init(top: 6, left: 0, bottom: -6, right: 0)
        return item
    }
    
    private func removeBadgeIfNeeded(for viewController: UIViewController) {
        guard
            let tabBarController = viewController.tabBarController as? TabBarViewController,
            let index = tabBarController.viewControllers?.firstIndex(of: viewController),
            tabBarController.tabItems?.hasBadge(at: index) ?? false else {
            return
        }
        
        let newBadgeNumber = max(UIApplication.shared.applicationIconBadgeNumber - 1, 0)
        UIApplication.shared.applicationIconBadgeNumber = newBadgeNumber
        
        tabBarController.tabItems?.removeBadge(at: index)
    }
}
