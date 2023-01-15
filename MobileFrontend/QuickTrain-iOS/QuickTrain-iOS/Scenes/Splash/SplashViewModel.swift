//
//  SplashViewModel.swift
//  QuickTrain-iOS
//

import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class SplashViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    let showLogin: PublishSubject<Void> = PublishSubject<Void>()
    
    init() {

    }

    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
