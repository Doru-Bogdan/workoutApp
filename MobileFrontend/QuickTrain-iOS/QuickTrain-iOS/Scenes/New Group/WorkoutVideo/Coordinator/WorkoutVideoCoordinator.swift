//
//  WorkoutVideoCoordinator.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 22.12.2020.
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

enum WorkoutCoordinationResult {
    case dismiss
}

class WorkoutVideoCoordinator: BaseCoordinator<WorkoutCoordinationResult> {
    private var rootViewController: UINavigationController
    private var workoutId: String?
    
    init(rootViewController: UINavigationController, workoutId: String) {
        self.rootViewController = rootViewController
        self.workoutId = workoutId
    }
    
    override func start() -> Observable<WorkoutCoordinationResult> {
        let viewModel = WorkoutVideoViewModel(workoutId: workoutId!)
        let viewController = WorkoutVideoViewController.instantiate()
        viewController.viewModel = viewModel
        
        let dismiss = viewModel.dismiss.map { _ in CoordinationResult.dismiss }
        
        rootViewController.pushViewController(viewController, animated: true)
        
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
