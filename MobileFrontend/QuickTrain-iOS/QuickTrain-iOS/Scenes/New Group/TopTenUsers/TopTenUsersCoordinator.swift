//
//  TopTenUsersCoordinator.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.01.2021.
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

enum TopTenUsersCoordinationResult {
    case dismiss
}

class TopTenUsersCoordinator: BaseCoordinator<TopTenUsersCoordinationResult> {
    private var rootViewController: UIViewController
    var navigationController: UINavigationController?
    var viewController: UIViewController!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<TopTenUsersCoordinationResult> {
        let viewModel = TopTenUsersViewModel()
        let viewController = TopTenUsersViewController.instantiate()
        
        navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        navigationController?.modalPresentationStyle = .fullScreen
        
        rootViewController.present(navigationController!, animated: true, completion: nil)
        self.viewController = viewController
        
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
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
