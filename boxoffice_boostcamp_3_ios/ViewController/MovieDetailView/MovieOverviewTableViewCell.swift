//
//  MovieOverviewTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 09/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieOverviewTableViewCell: UITableViewCell, ImageUtilityProtocol {
    // MARK:- Outlet
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gerneLabel: UILabel!
    
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet var starRateImageView: [UIImageView]!
    @IBOutlet weak var audienceLabel: UILabel!
    
    // MARK:- Properties
    weak public var delegate: HandleLargeThumbImageProtocol?
    weak private var thumbImage: UIImage?
    private var rate: Double = 0.0 {
        didSet {
            setStarRateImage(rate: rate)
            rateLabel?.text = String(format: "%.2f", rate)
        }
    }
    public var movieInfo: MovieDetail? {
        didSet {
            fetchMovieThumbImage(url: movieInfo?.image)
            rate = movieInfo?.userRating ?? 0.0
            titleLabel.text = movieInfo?.title
            dateLabel.text = movieInfo?.releaseDate
            gerneLabel.text = movieInfo?.genreAndDuration
            reservationLabel.text = movieInfo?.reservation
            audienceLabel.text = movieInfo?.audienceNumber
        }
    }
    
    // MARK:- Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleShowLargeImage(_:)))
        thumbImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK:- Set Star Rate Image
    private func setStarRateImage(rate: Double) {
        for i in starRateImageView.indices {
            starRateImageView[i].image = UIImage(named: self.starImageName(index: i, rate: rate))
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
    
    // MARK:- Show Large Thumb Image
    @objc func handleShowLargeImage(_ sender: UITapGestureRecognizer) {
        guard let image = thumbImage else { return }
        delegate?.showLargeThumbImage(image)
    }
}
