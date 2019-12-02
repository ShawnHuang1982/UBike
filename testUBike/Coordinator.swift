//
//  Coordinator.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/2.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

protocol Coordinator{
    func start()
}

struct StationStorage {
    var allStation: [StationDetail]?
}

class ApplicationCoordinator: Coordinator{
    
    let stationStorage: StationStorage
    let winodow: UIWindow
    let rootViewController: UINavigationController
    
    let allStationListCoordinator: AllStationListCoordinator
    
    init(window: UIWindow){
        self.winodow = window
        stationStorage = StationStorage()
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = false

//        let emptyViewController = UIViewController()
//        emptyViewController.view.backgroundColor = .cyan
//        rootViewController.pushViewController(emptyViewController, animated: false)
        allStationListCoordinator = AllStationListCoordinator(presenter: rootViewController, stationStorage: stationStorage)
    }
    
    func start() {
        winodow.rootViewController = rootViewController
        winodow.makeKeyAndVisible()
        allStationListCoordinator.start()
    }
    
    
}
