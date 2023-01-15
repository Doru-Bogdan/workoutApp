//
//  HomeViewController.swift
//  QuickTrain-iOS
//


import UIKit
import RxSwift
import Reusable
import CleanroomLogger
import SDWebImage
import SafariServices

class HomeViewController: UIViewController, StoryboardBased {

    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var categoriesStackView: UIStackView!
    @IBOutlet private weak var profileButton: UIButtonX!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViewModelBinding()
        viewModel.loadCategories()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        for category in categories {
            let videoView = VideoView(imageURL: category.thumbnail ?? "",
                                      description: category.type ?? "",
                                      typeId: category.workoutIdType ?? 0) { [self] categoryId in
                viewModel.goToCategoryVideos.onNext(categoryId)
            }
            categoriesStackView.addArrangedSubview(videoView)
        }
        viewModel.isLoading.onNext(false)
    }
    
    func createViewModelBinding() {
        viewModel.items.subscribe(onNext: { obj in
            self.categories = obj
            self.setupUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            if let urlString = AuthManager.shared.user?.certificateURL,
               let url = URL.init(string: urlString) {
                
                self.profileButton.sd_setImage(with: url, for: .normal)
            }}
            
        }).disposed(by: disposeBag)
        
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
        
        profileButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.goToProfileScreen.onNext(Void())
            }).disposed(by: disposeBag)
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let categories = self.categories.filter{($0.type?.lowercased().hasPrefix(searchText.lowercased()))!}
            categoriesStackView.isHidden = false
            for view in categoriesStackView.subviews {
                categoriesStackView.removeArrangedSubview(view)
            }
            
            if categories.count > 0 {
            for category in categories {
                let videoView = VideoView(imageURL: category.thumbnail ?? "",
                                          description: category.type ?? "",
                                          typeId: category.workoutIdType ?? 0) { [self] categoryId in
                    viewModel.goToCategoryVideos.onNext(categoryId)
                }
                categoriesStackView.addArrangedSubview(videoView)
            }} else {
                categoriesStackView.isHidden = true
            }
        } else {
            categoriesStackView.isHidden = false
            for view in categoriesStackView.subviews {
                categoriesStackView.removeArrangedSubview(view)
            }
            self.setupUI()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
