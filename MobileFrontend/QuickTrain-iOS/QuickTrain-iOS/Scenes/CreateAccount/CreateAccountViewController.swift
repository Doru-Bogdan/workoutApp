//
//  CreateAccountViewController.swift
//  QuickTrain-iOS
//


import UIKit
import RxSwift
import Reusable
import CleanroomLogger
import SkyFloatingLabelTextField

class CreateAccountViewController: UIViewController, StoryboardBased {

    var viewModel: CreateAccountViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var showConfirmPasswordButton: UIButton!
    @IBOutlet private weak var termsAcceptButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButtonX!
    @IBOutlet private weak var signInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createViewModelBinding()
    }
    
    func setupUI() {
        self.hideKeyboardWhenTappedAround()
        confirmPasswordTextField.textContentType = .confirmPassword
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        termsAcceptButton.setImage(UIImage(named: "circle"),
                                   for: .normal)
        termsAcceptButton.setImage(UIImage(named: "checkmark.circle.fill"),
                                          for: .selected)
        termsAcceptButton.addTarget(self,
                                    action: #selector(acceptTermsAction),
                                    for: .touchUpInside)
        
        let range = (signInLabel.text! as NSString).range(of: "Sign In")
        
        let attributedString = NSMutableAttributedString.init(string: signInLabel.text!)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemBlue,
                                        .font : UIFont.systemFont(ofSize: signInLabel.font.pointSize, weight: .semibold)], range: range)
        
        signInLabel.attributedText = attributedString
        signInLabel.isUserInteractionEnabled = true
        signInLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }
    
    func createViewModelBinding() {
        firstNameTextField.rx.text.orEmpty
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text.orEmpty
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPassword)
            .disposed(by: disposeBag)
        
        showPasswordButton.rx.tap
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.passwordTextField.showPassword(self.showPasswordButton)
            })
            .disposed(by: disposeBag)
        
        showConfirmPasswordButton.rx.tap
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.confirmPasswordTextField.showPassword(self.showConfirmPasswordButton)
            })
            .disposed(by: disposeBag)
        
        createAccountButton.rx.tap
            .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: viewModel.createAccount)
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
    
    @objc
    func acceptTermsAction() {
        termsAcceptButton.isSelected = !termsAcceptButton.isSelected
        viewModel.acceptTerms.accept(termsAcceptButton.isSelected)
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let range = (signInLabel.text! as NSString).range(of: "Sign In")

        if gesture.didTapAttributedTextInLabel(label: signInLabel, inRange: range) {
            viewModel.goToSignIn.onNext(Void())
        }
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = textField.text {
            switch textField.textContentType! {
            case .emailAddress:
                do {
                    let _ = try VailidatorFactory.validatorFor(type: .email).validated(textField.text)
                    emailTextField.errorMessage = ""
                } catch ValidationError.custom(let error) {
                    emailTextField.errorMessage = error
                } catch {
                    debugPrint(error.localizedDescription)
                }
            case .password:
                do {
                    let _ = try VailidatorFactory.validatorFor(type: .password).validated(textField.text)
                    passwordTextField.errorMessage = ""
                } catch ValidationError.custom(let error) {
                    passwordTextField.errorMessage = error
                } catch {
                    debugPrint(error.localizedDescription)
                }
                
            case .confirmPassword:
                if viewModel.checkConfirmPassword() {
                    confirmPasswordTextField.errorMessage = ""
                } else {
                    confirmPasswordTextField.errorMessage = "Passwords doesn't match"
                }
                
            default:
                return
            }
        }
    }
}
