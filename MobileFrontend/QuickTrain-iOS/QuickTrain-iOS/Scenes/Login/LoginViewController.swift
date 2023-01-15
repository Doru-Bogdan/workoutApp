//
//  LoginViewController.swift
//  QuickTrain-iOS
//

import UIKit
import Reusable
import CleanroomLogger
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, StoryboardBased {

    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var loginButton: UIButtonX!
    @IBOutlet private weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var createAccountLabel: UILabel!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        createViewModelBinding()
    }

    func setupUI() {
        passwordTextField.setRightPaddingPoints(40)
        
        let range = (createAccountLabel.text! as NSString).range(of: "Create account")
        
        let attributedString = NSMutableAttributedString.init(string: createAccountLabel.text!)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
                                        .font : UIFont.systemFont(ofSize: createAccountLabel.font.pointSize, weight: .semibold)], range: range)
        
        createAccountLabel.attributedText = attributedString
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }
    
    func createViewModelBinding() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        showPasswordButton.rx.tap
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.passwordTextField.showPassword(self.showPasswordButton)
            })
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: viewModel.login)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .subscribe(onNext: { (value) in
                Loader.shared.setActive(value)
            })
            .disposed(by: disposeBag)

        viewModel.errorMsg
            .subscribe(onNext: { (value) in
                Log.error?.message(value)
                BannerNotification.showNotification(title: "Error", subtitle: value, style: .danger)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let range = (createAccountLabel.text! as NSString).range(of: "Create account")

        if gesture.didTapAttributedTextInLabel(label: createAccountLabel, inRange: range) {
            viewModel.goToCreateAccount.onNext(Void())
        }
    }

    deinit {
        Log.debug?.message("deinit \(self)")
    }
}


extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
