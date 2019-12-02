//
//  AllStationListCoordinator.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/2.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class AllStationListCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var stationInMapViewController: StationInMapPageViewController?
    
    private var allStationList: [StationDetail]?
    private var stationListPageViewController: StationListPageViewController?
    
    private var myFavoritePageViewController: MyFavoriteStationViewController?
    
    private var stationStorage: StationStorage
    
    private var stationInMapCoordinate: StationInMapCoordinator?
    
    init(presenter: UINavigationController, stationStorage: StationStorage) {
        self.presenter = presenter
        self.allStationList = stationStorage.allStation
        self.stationStorage = stationStorage
    }
    
    func start() {
        let stationListPageViewController = StationListPageViewController(nibName: nil, bundle: Bundle.main)
        stationListPageViewController.title = "Station List 1"
        self.stationListPageViewController = stationListPageViewController
        presenter.pushViewController(stationListPageViewController, animated: true)
        
        self.stationListPageViewController?.delegate = self
        
    }
    
}

extension AllStationListCoordinator: StationListPageViewControllerDelegate{
    func stationListPageViewControllerDidSelectStation(_ selectedStation: UBikeRentInfoViewModel) {
        let stationInMapCoordinate = StationInMapCoordinator(presenter: presenter, station: selectedStation, stationStorage: stationStorage)
        
        self.stationInMapCoordinate = stationInMapCoordinate
        stationInMapCoordinate.start()
    }
}
