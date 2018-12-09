//
//  MovieCommentTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieCommentTableViewCell: UITableViewCell, ImageUtilityProtocol {
    // MARK:- Outlet
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet var starRateImageView: [UIImageView]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    // MARK:- Properties
    private var rate = 0.0 {
        didSet {
            setStarRateImage(rate: rate)
        }
    }
    public var comment: Comment? {
        didSet {
            rate = comment?.rating ?? 0.0
            writerLabel.text = comment?.writer
            dateLabel.text = comment?.dateAndTime
            contentsLabel.text = comment?.contents
        }
    }
    
    // MARK:- Set Star Rate Image
    private func setStarRateImage(rate: Double) {
        for i in starRateImageView.indices {
            starRateImageView[i].image = UIImage(named: self.starImageName(index: i, rate: rate))
        }
    }
    
    // MARK:- Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        comment = nil
    }
}