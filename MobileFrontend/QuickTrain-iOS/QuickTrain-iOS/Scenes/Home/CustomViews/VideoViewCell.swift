//
//  VideoViewCell.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import UIKit
import Kingfisher

class VideoViewCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var lockImageView: UIImageView!
    
    // MARK: - Properties
    private var videoThumbnail: VideoThumbnail?
    private var tapAction: ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureCell(videoThumbnail: VideoThumbnail, tapAction: @escaping (String) -> ()) {
        self.videoThumbnail = videoThumbnail
        self.tapAction = tapAction
        
        DispatchQueue.main.async {
            self.loadData()
        }
        
        setupUI()
        
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.6) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    func setupUI() {
        lockImageView.isHidden = true
        
        videoImageView.layer.masksToBounds = true
        videoImageView.layer.cornerRadius = 10
        if (AuthManager.shared.user?.level)! < (videoThumbnail?.requiredXp) ?? 0 {
            videoImageView.image = videoImageView.image?.darken()
            lockImageView.isHidden = false
        }
        
        videoDescriptionLabel.text = videoThumbnail?.title
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        videoImageView.pulsate()
        (AuthManager.shared.user?.level)! < (videoThumbnail?.requiredXp) ?? 0 ? nil : tapAction!((videoThumbnail?.id)!)
    }
    
    func loadData() {
        if let url = URL.init(string: (videoThumbnail?.thumbnailUrl)!) {
            videoImageView.kf.setImage(with: url, completionHandler: { imageResult,_,_,_ in
                (AuthManager.shared.user?.level)! < (self.videoThumbnail?.requiredXp) ?? 0 ? self.videoImageView.image = imageResult?.darken() : nil
            })
        }
    }
}
