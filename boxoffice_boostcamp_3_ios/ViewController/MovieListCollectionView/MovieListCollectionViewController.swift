//
//  MovieListCollectionViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 08/12/2018.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UIViewController {
    @IBOutlet weak var MovieListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MovieListCollectionView.delegate = self
        MovieListCollectionView.dataSource = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
    }
}

extension MovieListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension MovieListCollectionViewController: UICollectionViewDelegate {
    
}
