//
//  AddWorkoutViewController.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.03.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SkyFloatingLabelTextField
import GrowingTextView

class AddWorkoutViewController: UIViewController, StoryboardBased {

    private let disposeBag = DisposeBag()
    var viewModel: AddWorkoutViewModel!
    
    @IBOutlet weak var workoutTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutVideoUrlTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutThumbnailUrlTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutTypeIdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutRequiredXpTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutValueXpTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var workoutDescriptionTextView: GrowingTextView!
    @IBOutlet weak var createWorkoutButton: UIButtonX!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        createViewModelBinding()
    }
    
    func createViewModelBinding() {
        workoutTitleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutTitle)
            .disposed(by: disposeBag)
        
        workoutVideoUrlTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutVideoUrl)
            .disposed(by: disposeBag)
        
        workoutThumbnailUrlTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutThumbnailUrl)
            .disposed(by: disposeBag)
        
        workoutTypeIdTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutTypeId)
            .disposed(by: disposeBag)
        
        workoutRequiredXpTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutRequiredXp)
            .disposed(by: disposeBag)
        
        workoutValueXpTextField.rx.text
            .orEmpty
            .bind(to: viewModel.workoutValueXp)
            .disposed(by: disposeBag)
        
        workoutDescriptionTextView.rx.text
            .orEmpty
            .bind(to: viewModel.workoutDescription)
            .disposed(by: disposeBag)
        
        viewModel.showBanner.subscribe(onNext: {
            BannerNotification.showNotification(title: "Congratulations!",
                                                subtitle: "You have added a new exercise!",
                                                style: .info)
        }).disposed(by: disposeBag)
        
        viewModel.errorMsg
            .subscribe(onNext: { (value) in
                BannerNotification.showNotification(title: "Error", subtitle: value, style: .danger)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { (value) in
                Loader.shared.setActive(value)
            })
            .disposed(by: disposeBag)
        
        createWorkoutButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
            self?.viewModel.uploadNewExercise()
        }).disposed(by: disposeBag)
    }
}
