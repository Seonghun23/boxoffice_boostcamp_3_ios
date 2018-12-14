//
//  NetworkingErrorProtocol.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by ylabs on 14/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

// MARK:- Networking Error Protocol
protocol NetworkingErrorProtocol {
    func responseError(domain: String, code: Int) -> Error
}

extension NetworkingErrorProtocol {
    public func responseError(domain: String = "", code: Int = 404) -> Error {
        return NSError(domain: domain, code: code, userInfo: ["Message":"The Data couldn't read"])
    }
}
