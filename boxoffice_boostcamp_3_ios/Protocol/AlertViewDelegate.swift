//
//  AlertViewDelegate.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by bumslap on 19/01/2019.
//  Copyright © 2019 Seonghun Kim. All rights reserved.
//

import Foundation

protocol AlertViewDelegate: class {
    
    func shouldUpdateList(with sortType: SortType)
}
