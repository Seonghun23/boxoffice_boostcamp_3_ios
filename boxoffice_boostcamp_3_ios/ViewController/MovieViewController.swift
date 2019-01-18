//
//  MovieViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 12/15/18.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    /**
     Refresh Controller for TableView and CollectionView.
     
     This Property connected to refresh Method. If you add to it to TableView or CollectionView, You should override refresh method.
    */
    public lazy var refreshControl = UIRefreshControl()
    /*
     초반에 바로 초기화 되지 않아도 되는 인스탠스는 lazy로 선언하면 성능향상에 도움이 된다고 리뷰받은적이 있습니다. 참고하시면 좋을것 같습니다.
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    // MARK:- Refresh Method
    /**
     Action to refreshControl.
     
     This Method is Action to refreshControl. If you add to refreshControl to TableView or CollectionView, You should override this method.
     
     - parameters:
        - sender: It's UIRefreshControl which call this method.
     */
    @objc public func refresh(_ sender: UIRefreshControl) {
    }
    
    // MARK:- Alert Fail to Networking
    /**
     Present Alert Controller for Fail to Networking.
     
     This Method present Alert Controller for Fail to Networking. You can call it when Fail to Networking with Error.
     
     - parameters:
     - error: Error to Networking Fail.
     */
    public func showFailToNetworkingAlertController(error: Error?) {
        print(error?.localizedDescription ?? "Fail To Networing with No Error Message")
        
        let alertController = UIAlertController(title: nil, message: "영화목록을 가져오는데 실패했습니다.\n인터넷 연결을 확인해 주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
            }
        }
    }
}
