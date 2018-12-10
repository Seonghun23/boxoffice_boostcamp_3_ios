//
//  MovieListTableViewCell.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell, ImageUtilityProtocol {
    // MARK:- Outlet
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK:- Properties
    private var gradeImages = [String:UIImage]()
    private let placeholder = UIImage(named: "img_placeholder")
    public var movieInfo: MovieInfo? {
        didSet {
            initializeCell(info: movieInfo)
        }
    }
    
    // MARK:- Initialize
    private func initializeCell(info: MovieInfo?) {
        gradeImageView.image = setGradeImage(info?.grade)
        titleLabel?.text = info?.title
        rateLabel?.text = info?.tableViewRateString
        dateLabel?.text = info?.tableViewDateString
    }
    
    // MARK:- Set Grade Image
    private func setGradeImage(_ grade: Int?) -> UIImage? {
        guard let grade = grade else { return nil }
        if let image = gradeImages[gradeImageName(grade: grade)] {
            return image
        } else {
            DispatchQueue.global().async {
                let image = UIImage(named: self.gradeImageName(grade: grade))
                self.gradeImages[self.gradeImageName(grade: grade)] = image
                DispatchQueue.main.async {
                    self.gradeImageView.image = image
                }
            }
        }
        return nil
    }

    // MARK:- Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView.image = placeholder
        movieInfo = nil
    }
}
