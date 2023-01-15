//
//  ProfileViewModel.swift
//  QuickTrain-iOS
//


import Foundation
import RxSwift
import RxCocoa
import CleanroomLogger
import RealmSwift
import RxRealm

class ProfileViewModel {
    private let disposeBag = DisposeBag()
    
    //MARK: - Inputs
    
    
    
    //MARK: - Outputs
    let user: BehaviorRelay<User?> = BehaviorRelay<User?>(value: nil)
    let userAccount: BehaviorRelay<UserAccount?> = BehaviorRelay<UserAccount?>(value: nil)
    var isLoading: PublishSubject<Bool> = PublishSubject<Bool>()
    var errorMsg: PublishSubject<String> = PublishSubject<String>()
    let dismiss: PublishSubject<Void> = PublishSubject<Void>()
    
    init() { }
    
    func loadData() {
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getUserAccount)
            .filterSuccessfulStatusCodes()
            .map(GetAccountResponse.self)
            .subscribe { [self] event in
                switch event {
                case .success(let response):
                    self.userAccount.accept(response.data)
//                    let realm = try! Realm()
//                    print("Realm is located at:", realm.configuration.fileURL!)
                    
//                    Observable.from(optional: response.data)
//                        .subscribe(Realm.rx.add(update: .all))
//                        .disposed(by: disposeBag)

                    self.getUser()
                    
                case .failure(let error):
                                        BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
//                    let realm = try! Realm()
//                    let userAccount = realm.objects(UserAccount.self).first
//                    self.userAccount.accept(userAccount!)
//                    self.getUser()
//                    self.isLoading.onNext(false)
                }
            }.disposed(by: disposeBag)
    }
    
//    func deleteUserFromLocalDatabase() {
//        let realm = try! Realm()
//        try! realm.write {
//            realm.delete(self.userAccount.value!)
//            realm.delete(self.user.value!)
//        }
//    }
    
    func getUser() {
        NetworkManager.shared.provider.rx.request(WorkoutAPI.getUser(id: (AuthManager.shared.userAccount?.id)!))
            .filterSuccessfulStatusCodes()
            .map(GetUserResponse.self)
            .subscribe { [self] event in
                switch event {
                case .success(let response):
                    self.user.accept(response.user)
//                    Observable.from(optional: response.user)
//                        .subscribe(Realm.rx.add(update: .all))
//                        .disposed(by: disposeBag)

                case .failure(let error):
                    BannerNotification.showNotification(title: "Error",
                                                        subtitle: error.localizedDescription,
                                                        style: .danger)
//                    let realm = try! Realm()
//                    let user = realm.objects(User.self).first
//                    self.user.accept(user!)
                }
                self.isLoading.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    func getRank() -> String {
        guard let xp = user.value?.level else { return "" }
            
        
        if xp >= 0 && xp < 25 {
            return "Influencer wannabe"
        } else if xp >= 25 && xp < 50 {
            return "Tiny body"
        } else if xp >= 50 && xp < 100 {
            return "Standard benchpress lover"
        } else if xp >= 100 && xp < 200 {
            return "Gorilla"
        } else if xp >= 200 && xp < 400 {
            return "Gym addict"
        } else if xp >= 400 && xp < 800 {
            return "The rock"
        } else if xp >= 800 && xp < 2000 {
            return "Ronnie Coleman adept"
        } else if xp >= 2000 && xp < 10000 {
            return "Zeus"
        } else if xp >= 10000 && xp < 50000 {
            return "Hercules"
        } else {
            return "Adonis"
        }
    }

    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
