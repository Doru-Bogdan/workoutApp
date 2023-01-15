//
//  TopTenUsersViewModel.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.01.2021.
//

import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class TopTenUsersViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    

    
    // MARK: - Outputs
    let items: BehaviorRelay<[TopTenUser]> = BehaviorRelay<[TopTenUser]>(value: [])
    var isLoading : PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    let dismiss: PublishSubject<Void> = PublishSubject<Void>()
    let showVideo: PublishSubject<Int> = PublishSubject<Int>()
    
    init() { }
    
    func loadData() {
        self.isLoading.onNext(true)
        
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getTopTenUsers)
            .filterSuccessfulStatusCodes()
            .map(RankingResponse.self)
            .subscribe { [weak self] event in
                self?.isLoading.onNext(false)
                
                switch event {
                case .success(let resp):
                    self?.items.accept(resp.data)
                case .failure:
                    self?.errorMsg.onNext("Server error")
                }
            }.disposed(by: disposeBag)
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
