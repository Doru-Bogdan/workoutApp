//
//  CreateAccountCoordinator.swift
//  QuickTrain-iOS
//


import Foundation
import UIKit
import RxSwift
import CleanroomLogger

class CreateAccountCoordinator: BaseCoordinator<Void> {
    private var rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewModel = CreateAccountViewModel()
        let viewController = CreateAccountViewController.instantiate()
        viewController.viewModel = viewModel
        
        viewModel.goToSignIn.subscribe(onNext: {
            viewController.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        rootViewController.present(viewController, animated: true, completion: nil)
        
        return .never()
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
