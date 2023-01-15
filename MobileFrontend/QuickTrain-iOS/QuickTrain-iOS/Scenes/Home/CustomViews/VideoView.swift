//
//  VideoView.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 16.12.2020.
//

import Foundation
import UIKit
import CleanroomLogger

class VideoView: NibView {
    
    // MARK: - Outlets
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    
    // MARK: - Properties
    private var imageURL: String?
    private var descriptionText: String?
    private var typeId: Int?
    private var tapAction: ((Int) -> Void)?
    
    // MARK: - Initializer
    
    convenience init(imageURL: String, description: String, typeId: Int, tapAction: @escaping (Int)->()) {
        self.init()
        self.imageURL = imageURL
        self.descriptionText = description
        self.typeId = typeId
        self.tapAction = tapAction
        loadData()
    }
    
    override func setupUI() {
        videoImageView.layer.masksToBounds = true
        videoImageView.layer.cornerRadius = 10
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        videoImageView.pulsate()
        tapAction!(typeId!)
    }
    
    func loadData() {
        if let url = URL.init(string: imageURL!) {
            videoImageView.kf.setImage(with: url)
//            videoImageView.downloadedFrom(url: url)
        }
        
        videoDescriptionLabel.text = descriptionText
    }
    
    deinit {
        Log.debug?.message("deinit \(self)")
    }
}
