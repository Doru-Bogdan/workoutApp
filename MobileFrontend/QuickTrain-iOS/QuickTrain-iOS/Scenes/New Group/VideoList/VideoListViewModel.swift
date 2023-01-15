//
//  VideoListViewModel.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class VideoListViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    let categoryId: Int?

    
    // MARK: - Outputs
    let items: BehaviorRelay<[VideoThumbnail]> = BehaviorRelay<[VideoThumbnail]>(value: [])
    var isLoading : PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    let dismiss: PublishSubject<Void> = PublishSubject<Void>()
    let showVideo: PublishSubject<String> = PublishSubject<String>()
    
    init(categoryId: Int) {
        self.categoryId = categoryId
    }
    
    func loadData() {
        self.isLoading.onNext(true)
        
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getCategoryVideos(categoryId: self.categoryId!))
            .filterSuccessfulStatusCodes()
            .map([VideoThumbnail].self)
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
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
