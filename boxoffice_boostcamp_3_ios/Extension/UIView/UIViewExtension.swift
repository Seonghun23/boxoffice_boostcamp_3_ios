//
//  UIViewExtension.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by ylabs on 13/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

// MARK:- Remove All SubView
extension UIView {
    func removeAllSubview() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
