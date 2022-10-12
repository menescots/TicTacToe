//
//  UITextField+SecureToggle.swift
//  TicTacToe
//
//  Created by Agata Menes on 12/10/2022.
//

import Foundation
import UIKit

let button = UIButton(type: .custom)

extension UITextField {
    
    func enablePasswordToggle(){
        button.setImage(UIImage(named: "icons8-closed-eye-48"), for: .normal)
        button.setImage(UIImage(named: "icons8-open-eye-48"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
}
