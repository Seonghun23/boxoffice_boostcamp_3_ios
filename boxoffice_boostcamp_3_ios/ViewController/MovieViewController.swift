//
//  MovieViewController.swift
//  boxoffice_boostcamp_3_ios
//
//  Created by Seonghun Kim on 12/15/18.
//  Copyright © 2018 Seonghun Kim. All rights reserved.
//

import UIKit


/*
 baseController로서의 기능을 조금 더 보태기 위해 공통된 부분을 추가하였습니다. 또한 sortType 변경시 테이블뷰 컬렉션 뷰에 동시에 반응할 수 있도록 델리게이트 패턴을 추가하였습니다.
 */
class MovieViewController: UIViewController{
    /**
     Refresh Controller for TableView and CollectionView.
     
     This Property connected to refresh Method. If you add to it to TableView or CollectionView, You should override refresh method.
    */
    weak var alertViewDelegate: AlertViewDelegate?
    public lazy var refreshControl = UIRefreshControl()
    /*
     초반에 바로 초기화 되지 않아도 되는 인스탠스는 lazy로 선언하면 성능향상에 도움이 된다고 리뷰받은적이 있습니다. 참고하시면 좋을것 같습니다
     */
    
    public var sortType = MovieAPI.shared.sortType {
        didSet {
            switch sortType {
            case .reservation:
                navigationItem.title = "예매율순"
            case .curation:
                navigationItem.title = "큐레이션"
            case .date:
                navigationItem.title = "개봉일순"
                
            }
        }
    }

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
    
    public func showSortAlertController() {
        let alertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationAction = UIAlertAction(title: "예매율", style: .default) { _ in
            self.sortType = .reservation
            self.alertViewDelegate?.shouldUpdateList(with: .reservation)
        }
        let curationAction = UIAlertAction(title: "큐레이션", style: .default) { _ in
            self.sortType = .curation
            self.alertViewDelegate?.shouldUpdateList(with: .curation)
            
        }
        let dateAction = UIAlertAction(title: "개봉일", style: .default) { _ in
            self.sortType = .date
            self.alertViewDelegate?.shouldUpdateList(with: .date)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reservationAction)
        alertController.addAction(curationAction)
        alertController.addAction(dateAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
