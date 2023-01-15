//
//  BannerNotification.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 15/11/2020.
//

import Foundation
import NotificationBannerSwift

class BannerNotification {
    
    class func showNotification(title: String, subtitle: String, style: BannerStyle) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        let duration = Double((5 * subtitle.count) / 50)
        banner.duration = duration < 5 ? 5 : duration
        banner.show()
    }
    
}
