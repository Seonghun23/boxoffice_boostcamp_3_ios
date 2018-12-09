//
//  MovieStaffTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieStaffTableViewCell: UITableViewCell {
    // MARK:- Outlet
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    // MARK:- Properties
    public var movieInfo: MovieDetail? {
        didSet {
            directorLabel.text = movieInfo?.director
            actorLabel.text = movieInfo?.actor
        }
    }
}
