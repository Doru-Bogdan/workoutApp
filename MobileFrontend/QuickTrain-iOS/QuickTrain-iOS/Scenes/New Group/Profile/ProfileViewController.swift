//
//  ProfileViewController.swift
//  QuickTrain-iOS
//


import UIKit
import RxSwift
import RxCocoa
import Reusable
import CleanroomLogger

class ProfileViewController: UIViewController, StoryboardBased, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var viewModel: ProfileViewModel!
    let pickerController = UIImagePickerController()
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var pointsLabel: UILabel!
    @IBOutlet private weak var pointsImageView: UIImageView!
    @IBOutlet private weak var xpLabel: UILabel!
    @IBOutlet private weak var xpImageView: UIImageView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var addPhotoButton: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        createViewModelBinding()
        pickerController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData()
    }
    
    func setupUI() {
        self.title = "Profile"
        addLogoutButton()
        
        profileImageView.layer.cornerRadius = 85
        profileImageView.layer.masksToBounds = true
    }
    
    private func addLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Logout",
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.didTapLogout))
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc
    private func didTapLogout() {
        AuthManager.removeToken()
//        viewModel.deleteUserFromLocalDatabase()
    }
    
    func createViewModelBinding() {
        
        self.viewModel.userAccount
            .map {($0?.firstName ?? "") + " " + ($0?.lastName ?? "")}
            .bind(to: self.fullNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.userAccount
            .map {$0?.email}
            .bind(to: self.emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.userAccount
            .map {$0?.username}
            .bind(to: self.usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.user
            .map {("Current points: " + String(($0?.currentPoints ?? 0)))}
            .bind(to: self.pointsLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.user
            .map {("XP: " + String(($0?.level ?? 0)))}
            .bind(to: self.xpLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            if !isLoading {
                if let urlString = self?.viewModel.user.value?.certificateURL,
                   let url = URL.init(string: urlString) {
                    self?.profileImageView.kf.setImage(with: url)//downloadedFrom(url: url)
                }
                self?.setBadges()
                self?.rankLabel.text = self?.viewModel.getRank()
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func addProfilePhoto(_ sender: Any) {
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleToFill
            profileImageView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setBadges() {
        pointsImageView.image = (viewModel.user.value?.currentPoints!)! < 50 ? Images.timer : Images.singleWeight
        xpImageView.image = (viewModel.user.value?.level!)! < 100 ? Images.leg : Images.armWeight
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
