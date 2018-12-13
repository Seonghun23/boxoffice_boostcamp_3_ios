//
//  ImageUtilityProtocol.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

// MARK:- Image Assets Name Protocol
protocol ImageAssetsNameProtocol {
    func starRateImage(index: Int, rate: Double) -> UIImage?
    func fetchThumbImage(url: String, completiopn: @escaping(UIImage?) -> Void)
}

extension ImageAssetsNameProtocol {
    // MARK:- Return Star Rate Image
    public func starRateImage(index: Int, rate: Double) -> UIImage? {
        switch true {
        case rate >= (Double(index) * 2.0) + 2.0:
            return UIImage(named: "ic_star_large_full")
        case rate >= (Double(index) * 2.0) + 1.0 && rate < (Double(index) * 2.0) + 2.0:
            return UIImage(named: "ic_star_large_half")
        default:
            return UIImage(named: "ic_star_large")
        }
    }
    
    // MARK:- Fetch Thumb Image From URL
    public func fetchThumbImage(url: String, completiopn: @escaping(UIImage?) -> Void) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                completiopn(nil)
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            completiopn(image)
            
        }
    }
}
