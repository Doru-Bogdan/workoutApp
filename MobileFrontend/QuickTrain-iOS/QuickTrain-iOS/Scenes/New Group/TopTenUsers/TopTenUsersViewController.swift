//
//  TopTenUsersViewController.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 30.01.2021.
//

import UIKit
import Reusable
import CleanroomLogger
import RxSwift
import RxCocoa

class TopTenUsersViewController: UIViewController, StoryboardBased, UITableViewDelegate {

    var viewModel: TopTenUsersViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Outles
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadData()
        createViewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadData()
    }
    
    func setupUI() {
        self.title = "Top 10 of this month"
    }
    
    func createViewModelBinding() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.rowHeight = 80
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "TopTenUserCell",
                                         cellType: TopTenUserCell.self)) { (row, element, cell) in
                if let _ = element.firstName, let _ = element.lastName {
                    cell.configure(user: element, position: row)
                } else {
                    cell.isHidden = true
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

class TopTenUserCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var imageViewTrophy: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    func configure(user: TopTenUser, position: Int) {
        self.positionLabel.text = String(position + 1)
        self.firstNameLabel.text = user.firstName
        self.lastNameLabel.text = user.lastName
        self.pointsLabel.text = "Points: \(user.currentPoints ?? 0)"
        self.imageViewTrophy?.isHidden = false
        
        switch position {
        case 0:
            imageViewTrophy?.image = Images.trophy1
        case 1:
            imageViewTrophy?.image = Images.trophy2
        case 2:
            imageViewTrophy?.image = Images.trophy3
        default:
            imageViewTrophy?.isHidden = true
        }
    }
}
