//
//  UITextField.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 28.11.2020.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func showPassword(_ showPasswordButton: UIButton) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        let showPasswordButtonImage: UIImage!
        if #available(iOS 13.0, *) {
            showPasswordButtonImage = self.isSecureTextEntry ?  UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        } else {
            showPasswordButtonImage = self.isSecureTextEntry ? UIImage(named: "eye") : UIImage(named: "eye.slash")
        }
        showPasswordButton.setImage(showPasswordButtonImage, for: .normal)
    }
}
