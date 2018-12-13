//
//  MovieOverviewTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieOverviewTableViewCell: UITableViewCell, ImageAssetsNameProtocol, ViewLayoutUtilityProtocol {
    // MARK:- Outlet
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gerneLabel: UILabel!
    
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet var starRateImageView: [UIImageView]!
    @IBOutlet weak var audienceLabel: UILabel!
    
    // MARK:- Properties
    weak public var delegate: HandleShowLargeThumbImageProtocol?
    weak private var thumbImage: UIImage?
    private var rate: Double = 0.0 {
        didSet {
            setStarRateImage(rate: rate)
            rateLabel?.text = String(format: "%.2f", rate)
        }
    }
    public var movieInfo: MovieDetail? {
        didSet {
            initializeCell(info: movieInfo)
        }
    }
    
    // MARK:- Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMovieThumbImageView(_:)))
        thumbImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func initializeCell(info: MovieDetail?) {
        fetchMovieThumbImage(url: info?.image)
        setGradeView(grade: info?.gradeType, view: gradeView)
        rate = info?.userRating ?? 0.0
        titleLabel.text = info?.title
        dateLabel.text = info?.releaseDate
        gerneLabel.text = info?.genreAndDuration
        reservationLabel.text = info?.reservation
        audienceLabel.text = info?.audienceNumber
    }

    // MARK:- Set Star Rate Image
    private func setStarRateImage(rate: Double) {
        for (i, imageView) in starRateImageView.enumerated() {
            imageView.image = starRateImage(index: i, rate: rate)
        }
    }
    
    // MARK:- Fetch Thumb Image
    private func fetchMovieThumbImage(url: String?) {
        guard let url = url else { return }
        fetchThumbImage(url: url) { (thumb) in
            guard let image = thumb else { return }
            DispatchQueue.main.async {
                self.thumbImage = image
                self.thumbImageView.image = image
            }
        }
    }
    
    // MARK:- Tap Movie Thumb ImageView
    @objc private func tapMovieThumbImageView(_ sender: UITapGestureRecognizer) {
        guard let image = thumbImage else { return }
        delegate?.showLargeThumbImage(image)
    }
}
