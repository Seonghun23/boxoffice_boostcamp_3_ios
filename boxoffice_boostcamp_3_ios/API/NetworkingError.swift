//
//  NetworkingError.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import Foundation

class NetworkingError {
    public func responseError(domain: String = "", code: Int = 404) -> Error {
        return NSError(domain: domain, code: code, userInfo: ["Message":"The Data couldn't read"])
    }
}
