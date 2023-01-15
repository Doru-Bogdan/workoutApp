//
//  TabItems.swift
//  QuickTrain-iOS
//


import UIKit
import Reusable
import RxSwift
import SnapKit

class TabItems: UIView, NibLoadable {
    private static let badgeTag = 4261646765 // Hex for "Badge" :)
    
    @IBOutlet var button: [UIButton]!
    @IBOutlet var view: UIViewX!
    
    let didSelectTab = PublishSubject<Int>()
    
    override func layoutSubviews() {
        button.forEach { (button) in
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        // Select first tab
        button.first?.tintColor = Colors.mainColor
    }
    
    @IBAction private func didSelectTab(_ sender: UIButton) {
        deselectButtons()
        sender.tintColor = Colors.mainColor
        didSelectTab.onNext(sender.tag)
    }
    
    func selectTab(index: Int) {
        guard let selectedButton = button.filter({$0.tag == index}).first else { return }
        
        deselectButtons()
        selectedButton.tintColor = Colors.mainColor
    }
    
    func deselectButtons() {
        button.forEach { (button) in
            button.tintColor = UIColor.lightGray
        }
    }
}

// MARK: Badge management
extension TabItems {
    func addBadge(at index: Int) {
        guard button.indices.contains(index) else { return }
        
        removeBadge(at: index)
        
        let button = self.button[index]
        let badgeSize: CGFloat = 10
        let badge = Self.makeNotificationBadge(size: badgeSize)
        
        button.addSubview(badge)
        
        badge.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: badgeSize, height: badgeSize))
            $0.top.equalTo(button.snp.top)
            $0.centerX.equalTo(button.snp.centerX).offset(button.bounds.height / 2.0)
        }
    }

    func removeBadge(at index: Int) {
        guard button.indices.contains(index) else { return }
        button[index].viewWithTag(Self.badgeTag)?.removeFromSuperview()
    }
    
    func hasBadge(at index: Int) -> Bool {
        guard button.indices.contains(index) else { return false }
        return button[index].viewWithTag(Self.badgeTag) != nil
    }

    private static func makeNotificationBadge(size: CGFloat) -> UIView {
        let label = UILabel()
        label.layer.cornerRadius = size / 2
        label.clipsToBounds = true
        label.backgroundColor = .red
        label.textColor = .white
        label.text = nil
        label.tag = badgeTag
        return label
    }
}

