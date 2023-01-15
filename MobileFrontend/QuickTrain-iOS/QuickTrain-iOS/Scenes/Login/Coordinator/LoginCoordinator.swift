//
//  LoginCoordinator.swift
//  QuickTrain-iOS
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

enum LoginCoordinationResult: Equatable {
    case success(Bool)
    case cancel
}

class LoginCoordinator: BaseCoordinator<LoginCoordinationResult> {
    private var rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<CoordinationResult> {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController.instantiate()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        
        viewModel.goToCreateAccount.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            let coordinator = CreateAccountCoordinator(rootViewController: viewController)
            self.coordinate(to: coordinator).subscribe().disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        let cancel = viewModel.cancel.map { CoordinationResult.cancel }
        let success = viewModel.isSuccess.map { CoordinationResult.success($0) }
        
        rootViewController.present(viewController, animated: true, completion: nil)
        
        return Observable.merge(cancel, success)
            .take(1)
            .do(onNext: { [weak self] result in
                if result == .success(true) || result == .cancel {
                    self?.rootViewController.presentedViewController?.dismiss(animated: true)
                }
            })
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
