//
//  AddWorkoutViewModel.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.03.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct AddWorkoutViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    let workoutTitle = BehaviorRelay(value: "")
    let workoutVideoUrl = BehaviorRelay(value: "")
    let workoutThumbnailUrl = BehaviorRelay(value: "")
    let workoutTypeId = BehaviorRelay(value: "")
    let workoutRequiredXp = BehaviorRelay(value: "")
    let workoutValueXp = BehaviorRelay(value: "")
    let workoutDescription = BehaviorRelay(value: "")
    let showBanner = PublishSubject<Void>()
    
    // MARK: - Outputs
    var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    
    func uploadNewExercise() {
        isLoading.onNext(true)
        let newWorkout = WorkoutVideo(createdAt: nil,
                                      description: workoutDescription.value,
                                      id: nil,
                                      thumbnailURL: workoutThumbnailUrl.value,
                                      title: workoutTitle.value,
                                      updatedAt: nil,
                                      videoURL: workoutVideoUrl.value,
                                      workoutTypeID: Int(workoutTypeId.value),
                                      xpRequired:  Int(workoutRequiredXp.value),
                                      xpValue: Int(workoutValueXp.value))
        
        NetworkManager.shared.provider.rx.request(.uploadNewExercise(workoutVideo: newWorkout))
            .filterSuccessfulStatusCodes()
            .subscribe(onSuccess: { _ in
                isLoading.onNext(false)
                showBanner.onNext(Void())
            }, onError: { error in
                isLoading.onNext(false)
                errorMsg.onNext(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
