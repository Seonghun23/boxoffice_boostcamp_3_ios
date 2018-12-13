//
//  ViewLayoutUtility.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by ylabs on 13/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

// MARK:- View Layout Utility Protocol
protocol ViewLayoutUtilityProtocol {
    func setGradeView(grade: Grade?, view gradeView: UIView)
}

extension ViewLayoutUtilityProtocol {
    // MARK:- Set Grade View Layout
    public func setGradeView(grade: Grade?, view gradeView: UIView) {
        guard let grade = grade else {
            clearGradeView(gradeView)
            return
        }
        gradeView.backgroundColor = gradeViewColor(grade)
        gradeView.layer.cornerRadius = 1/2 * gradeView.bounds.size.height
        gradeView.layer.borderWidth = 0.0
        gradeView.layer.masksToBounds = true
    
        if let label = gradeView.viewWithTag(1000) as? UILabel {
            label.text = grade.rawValue
        } else {
            gradeView.removeAllSubview()
            let label = gradeLabel(grade)
            
            gradeView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: gradeView.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: gradeView.centerXAnchor).isActive = true
        }
    }
    
    // MARK:- Return Grade View Coloer
    private func gradeViewColor(_ grade: Grade) -> UIColor {
        switch grade {
        case .twelve:
            return #colorLiteral(red: 0.1618040502, green: 0.712597549, blue: 0.9660522342, alpha: 1)
        case .fifteen:
            return #colorLiteral(red: 0.9992727637, green: 0.6563023329, blue: 0.1463533044, alpha: 1)
        case .nineteen:
            return #colorLiteral(red: 0.9382794499, green: 0.3267629147, blue: 0.3156833649, alpha: 1)
        case .all:
            return #colorLiteral(red: 0.3987371325, green: 0.7319398522, blue: 0.4154791534, alpha: 1)
        }
    }
    
    // MARK:- Initialize Grade View
    private func clearGradeView(_ gradeView: UIView) {
        gradeView.backgroundColor = UIColor.clear
        if let label = gradeView.viewWithTag(1000) as? UILabel {
            label.text = ""
        } else {
            gradeView.removeAllSubview()
        }
    }
    
    // MARK:- Return Grade Label
    private func gradeLabel(_ grade: Grade) -> UILabel {
        let label = UILabel()
        label.text = grade.rawValue
        label.font.withSize(14)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.tag = 1000
        
        return label
    }
}

// MARK:- Movie Grade Enum
enum Grade: String {
    case twelve = "12"
    case fifteen = "15"
    case nineteen = "19"
    case all = "전체"
}
