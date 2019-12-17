//
//  StationInMapCoordinator.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/2.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class StationInMapCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var stationInMapPageViewController: StationInMapPageViewController?
    private var stationListPageViewController: StationListPageViewController?
    private var myFavoritePageViewController: MyFavoriteStationViewController?
    private var stationStorage: StationStorage
    private var station: UBikeRentInfoViewModel

    
    init(presenter: UINavigationController, station:UBikeRentInfoViewModel, stationStorage: StationStorage) {
        self.presenter = presenter
        self.station = station
        self.stationStorage = stationStorage
    }
    
    func start() {
        let stationInMapPageViewController = StationInMapPageViewController()
        stationInMapPageViewController.title = self.station.sarea
        
        presenter.pushViewController(stationInMapPageViewController, animated: true)
        self.stationInMapPageViewController = stationInMapPageViewController
    }
    
}
