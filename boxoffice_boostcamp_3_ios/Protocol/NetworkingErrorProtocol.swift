//
//  NetworkingErrorProtocol.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by ylabs on 14/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

/*
 스위프트 가이드 문서에 보면 프로토콜의 네이밍은 아래와 같은 방식을 추천하고 있습니다.
 
 Protocols that describe what something is should read as nouns (e.g. Collection).
 
 Protocols that describe a capability should be named using the suffixes able, ible, or ing (e.g. Equatable, ProgressReporting). */
import Foundation

// MARK:- Networking Error Protocol
protocol NetworkingErrorProtocol {
    func responseError(domain: String, code: Int, message: String) -> Error
}

extension NetworkingErrorProtocol {
    // MARK:- Return Custom Networking Response Error
    /**
     Return Custom Networking Error.
     
     This Method return Custom Error to Networking. You can get Error with Custom URL and Code.
     
     - parameters:
         - domain: URL Address to Error. Default is "".
         - code: Enter Networking Error Code. Default is 404.
         - message: Enter Custom Error Message. Default is "The Data couldn't read".
     */
    public func responseError(domain: String = "", code: Int = 404, message: String = "The Data couldn't read") -> Error {
        return NSError(domain: domain, code: code, userInfo: ["Message":message])
    }
}
