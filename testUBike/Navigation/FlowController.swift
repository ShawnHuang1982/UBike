//
//  FlowController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/4.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class FlowController: UIViewController {

    let listViewModels = ListViewModel()
    var viewModels: [UBikeRentInfoViewModel]?    
    
    let listVC = StationListPageViewController()
    
    private var stationInMapPageViewController: StationInMapPageViewController?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        listViewModels.fetchData()
        listViewModels.refreshViewClosure = {
            [unowned self, unowned listViewModels] in
            //debugPrint(viewModels.infos?.first)
            self.viewModels = listViewModels.infos
            DispatchQueue.main.async {
                self.listVC.viewModels = self.viewModels
                self.present(self.listVC, animated: false, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listVC.delegate = self
        
                
    }
    
}

extension FlowController: StationListPageViewControllerDelegate{
    func stationListPageViewControllerDidSelectStation(_ selectedStation: UBikeRentInfoViewModel) {
        
        let stationInMapPageViewController = StationInMapPageViewController()
        stationInMapPageViewController.title = selectedStation.sareaen
        self.presentVC(vc: stationInMapPageViewController)
        self.stationInMapPageViewController = stationInMapPageViewController
    }
    
    func presentVC(vc: UIViewController){
        let window = UIApplication.shared.keyWindow!
        if let modalVC = window.rootViewController?.presentedViewController {
            modalVC.present(vc, animated: true, completion: nil)
        } else {
            window.rootViewController!.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
