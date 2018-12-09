//
//  MovieSynopsisTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieSynopsisTableViewCell: UITableViewCell {
    // MARK:- Outlet
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // MARK:- Properties
    public var movieInfo: MovieDetail? {
        didSet {
            synopsisLabel.text = movieInfo?.synopsis
        }
    }
}
