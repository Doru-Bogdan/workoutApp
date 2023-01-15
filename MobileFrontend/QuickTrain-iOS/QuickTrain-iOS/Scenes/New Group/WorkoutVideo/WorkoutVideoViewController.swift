//
//  WorkoutVideoViewController.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 22.12.2020.
//

import UIKit
import Reusable
import CleanroomLogger
import RxSwift
import RxCocoa
import youtube_ios_player_helper

class WorkoutVideoViewController: UIViewController, StoryboardBased {

    var viewModel: WorkoutVideoViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Outlets
    @IBOutlet private weak var videoView: YTPlayerView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var xpValueLabel: UILabel!
    @IBOutlet private weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.loadData()
        createViewModelBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.addXpToUser()
    }
    
    
    func createViewModelBinding() {
        navigationItem.leftBarButtonItem?.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel?.dismiss.onNext(Void())
            })
            .disposed(by: disposeBag)
        
        viewModel.items.subscribe(onNext: { workout in
            self.setupUI(workout)
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
        
        viewModel.timeSpentOnVideo = 0
    }
    
    func setupUI(_ workout: WorkoutVideo) {
        viewModel.videoXp = workout.xpValue
        
        videoView.delegate = self
        videoView.load(withVideoId: workout.videoURL ?? "")
        
        descriptionTextView.text = workout.description
        xpValueLabel.text = "XP value: \(workout.xpValue ?? 0)"
        pointsLabel.text = "Points: \(viewModel.getWorkoutTypePoints())"
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}

extension WorkoutVideoViewController: YTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.gray
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoView.duration() { [weak self] time, error in
            self?.viewModel.videoDuration = time
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing {
            viewModel.timeForVideoStart = Timer()
        } else if state == .paused || state == .ended {
            if let elapsedTime = viewModel.timeForVideoStart?.stop() {
                viewModel.timeSpentOnVideo! += elapsedTime
            }
        }
    }
}
