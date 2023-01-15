//
//  AppCoordinator.swift
//  QuickTrain-iOS
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController.instantiate()
        viewController.viewModel = viewModel
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        AuthManager.shared.tokenChanged
            .subscribe(onNext: { token in
                if token == nil {
                    Log.debug?.message("Logout initiated, dismiss all screens and show login screen")
                    
                    viewController.presentedViewController?.dismiss(animated: true, completion: {
                        viewModel.showLogin.onNext(Void())
                    })
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showLogin
            .flatMap { [weak self] _ -> Observable<Bool?> in
                guard let `self` = self else { return .empty() }
                return self.showLoginScreen(on: viewController)
            }
            .subscribe(onNext: { [weak self] result in
                if result == true {
                    self?.showMainScreen(on: viewController)
                }
                
                if result == nil {
                    viewModel.showLogin.onNext(Void())
                }
            })
            .disposed(by: disposeBag)
        
        if AuthManager.shared.token != nil {
            self.showMainScreen(on: viewController)
        } else {
            viewModel.showLogin.onNext(Void())
        }

        return .never()
    }
    
    private func showLoginScreen(on rootViewController: UIViewController) -> Observable<Bool?> {
        let loginCoordinator = LoginCoordinator(rootViewController: rootViewController)
        return coordinate(to: loginCoordinator)
            .map { result in
                switch result {
                case .success(let result): return result
                case .cancel: return nil
                }
        }
    }
    
    private func showMainScreen(on rootViewController: UIViewController) {
        let mainCoordinator = RootCoordinator(rootViewController: rootViewController)
        coordinate(to: mainCoordinator).subscribe().disposed(by: disposeBag)
    }
}
