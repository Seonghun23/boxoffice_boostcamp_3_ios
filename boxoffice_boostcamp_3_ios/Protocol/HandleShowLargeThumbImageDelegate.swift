//
//  HandleLargePosterImageProtocol.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit
/*
 스위프트 가이드 문서에 보면 프로토콜의 네이밍은 아래와 같은 방식을 추천하고 있습니다.
 
 Protocols that describe what something is should read as nouns (e.g. Collection).

Protocols that describe a capability should be named using the suffixes able, ible, or ing (e.g. Equatable, ProgressReporting). */



// MARK:- Handle Show Large Thumb Image Protocol
protocol HandleShowLargeThumbImageDelegate: class {
    func showLargeThumbImage(_ image: UIImage)
}
