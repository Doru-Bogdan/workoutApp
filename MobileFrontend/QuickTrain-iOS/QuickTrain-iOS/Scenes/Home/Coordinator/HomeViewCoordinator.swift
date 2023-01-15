//
//  HomeViewCoordinator.swift
//  QuickTrain-iOS
//


import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

enum HomeViewCoordinationResult {
    case dismiss
}

class HomeViewCoordinator: BaseCoordinator<HomeViewCoordinationResult> {
    private var rootViewController: UITabBarController
    var viewController: UIViewController!
    
    init(rootViewController: UITabBarController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<HomeViewCoordinationResult> {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController.instantiate()

        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        self.viewController = viewController
        
        rootViewController.present(viewController, animated: true)
        
        viewModel.goToCategoryVideos.subscribe(onNext: { [weak self] categoryId in
            guard let self = self else { return }
            
            self.goToVideoList(viewController: self.viewController.navigationController!, categoryId: categoryId)
        }).disposed(by: disposeBag)
        
        viewModel.goToProfileScreen.subscribe(onNext: { [weak self] _ in
            self?.goToProfileScreen()
        }).disposed(by: disposeBag)
        
        let dismiss = viewModel.dismiss.map { _ in CoordinationResult.dismiss }
        
        return dismiss
            .take(1)
            .do(onNext: { [weak viewController] result in
                switch result {
                case .dismiss:
                    viewController?.dismiss(animated: true, completion: nil)
                }
            })
    }
    
    private func goToVideoList(viewController: UINavigationController, categoryId: Int) {
        let videoListScreen = VideoListCoordinator(rootViewController: viewController, workoutTypeId: categoryId)
        coordinate(to: videoListScreen).subscribe().disposed(by: disposeBag)
    }
    
    private func goToProfileScreen() {
        if let tabbar = rootViewController as? TabBarViewController {
            tabbar.selectedIndex = 1
            tabbar.tabItems?.selectTab(index: 1)
        }
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
