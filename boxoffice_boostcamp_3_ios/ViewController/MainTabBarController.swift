//
//  MainTabBarController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by bumslap on 19/01/2019.
//  Copyright © 2019 Seonghun Kim. All rights reserved.
//

import UIKit
/*
 루트뷰인 tabBarController 와 연결하여 전체적인 처리를 위해 델리게이트 패턴을 사용해보았습니다.
 */
class MainTabBarController: UITabBarController, AlertViewDelegate {
    
    var tableViewController: MovieListTableViewController?
    var collectionViewController: MovieListCollectionViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllers()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewControllers() {
        guard let tableNavigationViewController = viewControllers?[0] as? UINavigationController, let collectionNavigationViewController = viewControllers?[1] as? UINavigationController else {
            return
        }
        guard let tableViewController = tableNavigationViewController.viewControllers[0] as? MovieListTableViewController, let collectionViewController = collectionNavigationViewController.viewControllers[0] as? MovieListCollectionViewController else {
            return
        }
        self.tableViewController = tableViewController
        self.collectionViewController = collectionViewController
        
        self.tableViewController?.alertViewDelegate = self
        self.collectionViewController?.alertViewDelegate = self
    }
    // 델리게이트 프로토콜의 메서드로서 호출되면 각 뷰의 데이터를 sortType에 따라서 새로 받아오는 메서드를 호출합니다.
    func shouldUpdateList(with sortType: SortType) {
        tableViewController?.fetchMovieList(sort: sortType)
        collectionViewController?.fetchMovieList(sort: sortType)
    }
    
}
