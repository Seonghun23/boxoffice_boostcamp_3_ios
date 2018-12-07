//
//  MovieListTableViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListTableViewController: UIViewController {
    @IBOutlet weak var MovieListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MovieListTableView.delegate = self
        MovieListTableView.dataSource = self
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
}

extension MovieListTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MovieListTableViewController: UITableViewDelegate {
    
}
