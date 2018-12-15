//
//  UIViewExtension.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by ylabs on 13/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

extension UIView {
    // MARK:- Remove All SubView
    /**
     Remove All Subview to Self.
     
     This Method remove all Subview. If you want to remove specific View, Don't Call this Method.
     */
    func removeAllSubview() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
