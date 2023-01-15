//
//  LoginViewModel.swift
//  QuickTrain-iOS
//


import Foundation

import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class LoginViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Inputs
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let cancel: PublishSubject<Void> = PublishSubject<Void>()
    let showPassword: PublishSubject<Void> = PublishSubject<Void>()
    let goToCreateAccount: PublishSubject<Void> = PublishSubject<Void>()
    
    // MARK: - Outputs
    var isSuccess: PublishSubject<Bool> = PublishSubject<Bool>()
    var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()

    init() {
        AuthManager.shared.tokenChanged
            .subscribe(onNext: { [weak self] token in
                if token != nil {
                    self?.isLoading.onNext(false)
                    self?.isSuccess.onNext(true)
                } else {
                    self?.isLoading.onNext(false)
                    self?.isSuccess.onNext(false)
                }
            }, onError: { [weak self] error in
                Log.error?.message(error.localizedDescription)
                self?.isLoading.onNext(false)
                self?.errorMsg.onNext("error login")
            })
            .disposed(by: disposeBag)
    }
    
    func login() {
        isLoading.onNext(true)

        NetworkManager.shared.provider.rx.request(
            .login(email: email.value, password: password.value)
            )
            .filterSuccessfulStatusCodes()
        .map(LoginResponse.self)
            .subscribe { [self] event in

                switch event {
                case .success(let response):
                    AuthManager.setToken(token: response.data.token)
                    self.getUserAccount()
                    
                case .failure(let error):
                    self.isLoading.onNext(false)
                    BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
                }
        }
        .disposed(by: disposeBag)
    }
    
    func getUserAccount() {
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getUserAccount)
            .filterSuccessfulStatusCodes()
            .map(GetAccountResponse.self)
            .subscribe { [self] event in
                switch event {
                case .success(let response):
                    AuthManager.setUserAccount(userAccount: response.data!)
                    self.getUser()
                    
                case .failure(let error):
                    self.isLoading.onNext(false)
                    BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
                }
            }.disposed(by: disposeBag)
    }
    
    func getUser() {
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getUser(id: (AuthManager.shared.userAccount?.id)!))
            .filterSuccessfulStatusCodes()
            .map(GetUserResponse.self)
            .subscribe { [self] event in
                self.isLoading.onNext(false)

                switch event {
                case .success(let response):
                    AuthManager.setUser(user: response.user!)

                case .failure(let error):
                    BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
                }
            }.disposed(by: disposeBag)
    }

    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
