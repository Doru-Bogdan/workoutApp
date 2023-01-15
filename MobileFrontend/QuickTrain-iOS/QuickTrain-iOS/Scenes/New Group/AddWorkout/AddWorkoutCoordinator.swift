//
//  AddWorkoutCoordinator.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.03.2021.
//

import Foundation
import UIKit
import RxSwift
import CleanroomLogger

class AddWorkoutCoordinator: BaseCoordinator<Void> {
    private var rootViewController: UIViewController
    var navigationController: UINavigationController?
    var viewController: UIViewController!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = AddWorkoutViewController.instantiate()
        let viewModel = AddWorkoutViewModel()
        viewController.viewModel = viewModel
        
        navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController?.modalPresentationStyle = .fullScreen
        self.viewController = viewController
        
        rootViewController.present(navigationController!, animated: true, completion: nil)
        
        return .never()
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
