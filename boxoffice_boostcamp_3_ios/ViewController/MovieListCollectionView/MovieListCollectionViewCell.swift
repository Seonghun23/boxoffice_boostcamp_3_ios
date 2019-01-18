//
//  MovieListCollectionViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell, Fetchable, GradeImageCaculating {
    // MARK:- Outlet
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK:- Properties
    private let placeholder = UIImage(named: "img_placeholder")
    public var movieInfo: MovieInfo? {
        didSet {
            initializeCell(info: movieInfo)
        }
    }

    // MARK:- Initialize
    private func initializeCell(info: MovieInfo?) {
        setGradeView(grade: info?.gradeType, view: gradeView) // Set Label to Subview with Tag 1000
        titleLabel?.text = info?.title
        rateLabel?.text = info?.collectionViewRateString
        dateLabel?.text = info?.date
    }
    
    // MARK:- Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView.image = placeholder
        movieInfo = nil
    }
}
