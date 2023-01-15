//
//  WorkoutVideoViewModel.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 22.12.2020.
//

import Foundation

import RxSwift
import RxCocoa
import CleanroomLogger

class WorkoutVideoViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    let workoutId: String?

    
    // MARK: - Outputs
    let items: BehaviorRelay<WorkoutVideo> = BehaviorRelay<WorkoutVideo>(value: WorkoutVideo())
    var isLoading : PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    let dismiss: PublishSubject<Void> = PublishSubject<Void>()
    
    // MARK: - Properties
    var videoDuration: Double?
    var timeSpentOnVideo: Double?
    var videoXp: Int?
    var timeForVideoStart: Timer?
    
    init(workoutId: String) {
        self.workoutId = workoutId
    }
    
    func loadData() {
        self.isLoading.onNext(true)
        
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getWorkout(workoutId: workoutId!))
            .filterSuccessfulStatusCodes()
            .map(WorkoutVideo.self)
            .subscribe { [weak self] event in
                self?.isLoading.onNext(false)
                
                switch event {
                case .success(let resp):
                    self?.items.accept(resp)
                case .failure:
                    self?.errorMsg.onNext("Server error")
                }
            }.disposed(by: disposeBag)
    }
    
    func updateUserPoints() {
        NetworkManager.shared.provider.rx.request(WorkoutAPI.updateUser(user: AuthManager.shared.user!))
            .filterSuccessfulStatusCodes()
            .subscribe { [weak self] event in
                switch event {
                case .success:
                    debugPrint("User updated success")
                case .failure:
                    self?.errorMsg.onNext("Server error")
                }
            }.disposed(by: disposeBag)
    }
    
    func getWorkoutTypePoints() -> Int {
        switch items.value.workoutTypeID {
        case 0:
            return 8
        case 1:
            return 10
        case 2:
            return 20
        default:
            return 1
        }
    }
    
    func addXpToUser() {
        if 0.8 * videoDuration! < timeSpentOnVideo! {
            AuthManager.shared.user?.level! += videoXp!
            AuthManager.shared.user?.currentPoints! += self.getWorkoutTypePoints()
            updateUserPoints()
            BannerNotification.showNotification(title: "Congratulations!",
                                                subtitle: "You have gained \(items.value.xpValue ?? 0) XP and \(self.getWorkoutTypePoints()) points for this month!",
                                                style: .info)
        }
    }

    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
