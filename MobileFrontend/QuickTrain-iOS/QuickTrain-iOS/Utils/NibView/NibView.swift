//
//  NibView.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 16.12.2020.
//

import UIKit

class NibView: UIView, NibOwnerLoadable {

    // MARK: - Init/Deinit

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNibContent()
        //loadFromNib()
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadNibContent()
        //loadFromNib()
        setupUI()
    }

    deinit {
        print("☠️ deinit called on \(NSStringFromClass(type(of: self)))")
    }

    // MARK: - Defaults

    func loadNib() { fatalError("\(#function) must NOT be overridden") }

    func setupUI() { fatalError("super.\(#function) must NOT be called") }

}
