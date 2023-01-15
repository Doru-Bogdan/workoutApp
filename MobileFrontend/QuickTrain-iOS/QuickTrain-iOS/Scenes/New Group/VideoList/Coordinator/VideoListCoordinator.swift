//
//  VideoListCoordinator.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import Foundation
import UIKit
import Reusable
import CleanroomLogger
import RxSwift

enum VideoListCoordinationResult {
    case dismiss
}

class VideoListCoordinator: BaseCoordinator<VideoListCoordinationResult> {
    private var rootViewController: UINavigationController
    private var workoutTypeId: Int?
    
    init(rootViewController: UINavigationController, workoutTypeId: Int) {
        self.rootViewController = rootViewController
        self.workoutTypeId = workoutTypeId
    }
    
    override func start() -> Observable<VideoListCoordinationResult> {
        let viewModel = VideoListViewModel(categoryId: workoutTypeId!)
        let viewController = VideoListViewController.instantiate()
        
        viewController.viewModel = viewModel
        rootViewController.pushViewController(viewController, animated: true)
        viewModel.showVideo.subscribe(onNext: { [weak self] workoutId in
            guard let self = self else { return }

            let coordinator = WorkoutVideoCoordinator(rootViewController: self.rootViewController, workoutId: workoutId)
            self.coordinate(to: coordinator).subscribe().disposed(by: self.disposeBag)
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
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
