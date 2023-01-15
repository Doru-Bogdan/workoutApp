//
//  VideoListViewController.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import UIKit
import Reusable
import CleanroomLogger
import RxSwift
import RxCocoa
import SwiftGifOrigin

class VideoListViewController: UIViewController, StoryboardBased, UITableViewDelegate {

    var viewModel: VideoListViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadData()
        createViewModelBinding()
    }
    
    func setupUI() {
        self.title = "Videos"
        tableView.register(UINib(nibName: "VideoViewCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func createViewModelBinding() {
        navigationItem.leftBarButtonItem?.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel?.dismiss.onNext(Void())
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rowHeight = 236
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "VideoCell",
                                         cellType: VideoViewCell.self)) { (row, element, cell) in
                cell.configureCell(videoThumbnail: element) { [self] id in
                    viewModel.showVideo.onNext(id)
                }
            }
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
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
