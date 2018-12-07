//
//  MovieInformationViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieInformationViewController: UIViewController {
    @IBOutlet weak var MovieInformationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MovieInformationTableView.allowsSelection = false
        MovieInformationTableView.delegate = self
        MovieInformationTableView.dataSource = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension MovieInformationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 10
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
            return UITableViewCell()
        case 1:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
            return UITableViewCell()
        case 2:
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
        
        
    }
}

extension MovieInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2 else { return nil }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 10
        default:
            return 0
        }
    }
}

// MARK:- Show Large Poster Image
extension MovieInformationViewController: HandleLargePosterImageProtocol {
    func showLargePosterImage(_ image: UIImage) {
        guard let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoviePosterViewController") as? MoviePosterViewController else {
            print("Fail to create MoviePosterViewController")
            return
        }
        VC.posterImage = image
        present(VC, animated: true, completion: nil)
    }
}
