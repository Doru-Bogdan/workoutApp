//
//  CreateAccountViewModel.swift
//  QuickTrain-iOS
//


import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger

class CreateAccountViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let confirmPassword = BehaviorRelay(value: "")
    let firstName = BehaviorRelay(value: "")
    let lastName = BehaviorRelay(value: "")
    let username = BehaviorRelay(value: "")
    let acceptTerms: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let goToSignIn: PublishSubject<Void> = PublishSubject<Void>()
    
    // MARK: - Outputs
    var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    
    init() {
        
    }
    
    func checkFields() -> Bool {
        if !acceptTerms.value {
            BannerNotification.showNotification(title: "Warning",
                                                subtitle: "Terms and conditions not accepted",
                                                style: .warning)
            return false
        } else if !checkConfirmPassword() {
            BannerNotification.showNotification(title: "Warning",
                                                subtitle: "Passwords don't match",
                                                style: .warning)
            return false
        } else if email.value.isEmpty || username.value.isEmpty {
            BannerNotification.showNotification(title: "Warning",
                                                subtitle: "Email and username are required",
                                                style: .warning)
            return false
        }
        
        return true
    }
    
    func createAccount() {
        if checkFields() {
            isLoading.onNext(true)
            let user = GenericUser(email: email.value,
                                   username: username.value,
                                   password: password.value,
                                   firstName: firstName.value,
                                   lastName: lastName.value)
            
            NetworkManager.shared.provider.rx.request(
                .register(user: user)
            )
            .filterSuccessfulStatusCodes()
            .subscribe { [weak self] event in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                
                switch event {
                case .success:
                    BannerNotification.showNotification(title: "Success",
                                                        subtitle: "Account successfully created",
                                                        style: .success)
                    self.goToSignIn.onNext(Void())
                    
                case .failure(let error):
                    BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
                }
            }
            .disposed(by: disposeBag)
        }
    }
    
    func checkConfirmPassword() -> Bool{
        return password.value == confirmPassword.value
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
