//
//  MovieCommentTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieCommentTableViewCell: UITableViewCell, Fetchable {
    // MARK:- Outlet
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet var starRateImageView: [UIImageView]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    // MARK:- Properties
    private var starImage = [String:UIImage]()
    private var rate = 0.0 {
        didSet {
            setStarRateImage(rate: rate)
        }
    }
    public var comment: Comment? {
        didSet {
            initializeCell(info: comment)
        }
    }
    
    // MARK:- Initialize
    private func initializeCell(info: Comment?) {
        rate = info?.rating ?? 0.0
        writerLabel.text = info?.writer
        dateLabel.text = info?.dateAndTime
        contentsLabel.text = info?.contents
    }
    
    // MARK:- Set Star Rate Image
    private func setStarRateImage(rate: Double) {
        for (i, imageView) in starRateImageView.enumerated() {
            imageView.image = selectStarRateImage(index: i, rate: rate)
        }
    }
    
    // MARK:- Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        comment = nil
    }
}
