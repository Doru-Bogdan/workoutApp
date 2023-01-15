//
//  HomeViewModel.swift
//  QuickTrain-iOS
//


import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    
    
    // MARK: - Outputs
    let items: BehaviorRelay<[Category]> = BehaviorRelay<[Category]>(value: [])
    let goToCategoryVideos: PublishSubject<Int> = PublishSubject<Int>()
    let goToProfileScreen: PublishSubject<Void> = PublishSubject<Void>()
    var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    let dismiss: PublishSubject<Void> = PublishSubject<Void>()
    
    init() { }
    
    func loadCategories() {
        self.isLoading.onNext(true)
        
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getAllWorkoutTypes)
            .filterSuccessfulStatusCodes()
            .map([Category].self)
            .subscribe { [weak self] event in
                switch event {
                case .success(let resp):
                    self?.items.accept(resp)
                case .failure:
                    self?.errorMsg.onNext("Server error")
                }
            }.disposed(by: disposeBag)
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
