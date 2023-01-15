//
//  SplashViewController.swift
//  QuickTrain-iOS
//
//

import UIKit
import Reusable
import CleanroomLogger
import RxSwift
import RxCocoa

class SplashViewController: UIViewController, StoryboardBased {
    
    var viewModel: SplashViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var splashLogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createViewModelBinding()
    }
    
    func createViewModelBinding() {

    }
    
    func setupUI() {
        splashLogoImage.image = UIImage(named: "logo")
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
