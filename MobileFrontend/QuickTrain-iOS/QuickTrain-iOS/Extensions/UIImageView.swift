//
//  UIImageView.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 12.12.2020.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, withDarkerImage: Bool = false) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = image
                    }
                }.resume()
    }
    func downloadedFrom(link: String, withDarkerImage: Bool = false) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, withDarkerImage: withDarkerImage)
    }
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 0.95
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        
        layer.add(pulse, forKey: "pulse")
    }
}
