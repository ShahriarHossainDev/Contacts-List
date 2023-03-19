//
//  Constants.swift
//  Contacts List
//
//  Created by Shishir_Mac on 19/3/23.
//

import Foundation
import UIKit

extension UIView {
    // UIView Shadow function
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
        
    }
}
