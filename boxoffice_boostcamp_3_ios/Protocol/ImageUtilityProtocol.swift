//
//  ImageUtilityProtocol.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation
import UIKit

protocol ImageUtilityProtocol {
    func starImageName(index: Int, rate: Double) -> String
    func gradeImageName(grade: Int) -> String
    func fetchThumbImage(url: String, completiopn: @escaping(UIImage?) -> Void)
}

extension ImageUtilityProtocol {
    // MARK:- Return Star Image Asset Name
    func starImageName(index: Int, rate: Double) -> String {
        switch true {
        case rate >= (Double(index) * 2.0) + 2.0:
            return "ic_star_large_full"
        case rate >= (Double(index) * 2.0) + 1.0 && rate < (Double(index) * 2.0) + 2.0:
            return "ic_star_large_half"
        default:
            return "ic_star_large"
        }
    }
    
    // MARK:- Return Grade Image Asset Name
    func gradeImageName(grade: Int) -> String {
        if grade == 0 {
            return "ic_allages"
        } else {
            return "ic_" + String(format: "%d", grade)
        }
    }
    
    // MARK:- Fetch Image From URL
    func fetchThumbImage(url: String, completiopn: @escaping(UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: url),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
                else {
                    completiopn(nil)
                    return
            }
            completiopn(image)
        }
    }
}
