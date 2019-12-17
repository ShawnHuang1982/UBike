//
//  FlowController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/4.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit
import CoreLocation

class FlowController: UIViewController {

    var collectionView: UICollectionView!
    let flowControlViewModel = FlowControlViewModel()

    var tabBarView: TabBarView!
    lazy var listVC: StationListPageViewController = StationListPageViewController()
    lazy var mapVC: StationInMapPageViewController = StationInMapPageViewController()
    lazy var myFavoriteVC: MyFavoriteStationViewController = MyFavoriteStationViewController()
    
    var viewcontrollers: [UIViewController] = []
    var views: [UIView] = []
    var timer: Timer?
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    var myFavoriteViewModels: [UBikeRentInfoViewModel]?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        initView()
        setViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listVC.delegate = self
        myFavoriteVC.delegate = self
        setTimer(isOn: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setTimer(isOn: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func requestPermission(){
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
        }
    }
    
    private func setViewModel(){
        //bind view <- viewModel
        flowControlViewModel.refreshViewClosure = {
            [unowned self, unowned flowControlViewModel] in
            flowControlViewModel.userLocation = self.userLocation
            let infos = self.userLocation != nil ? flowControlViewModel.sortedInfosByLocation : flowControlViewModel.sortedInfos
            self.listVC.viewModels = infos
            self.mapVC.listViewModel = infos
            self.myFavoriteVC.viewModels = infos?.filter{$0.isFavorite == true}
            self.updateFavoriteUI()
            debugPrint("refreshViewClosure")
        }
        
        //fetch data
        flowControlViewModel.fetchData()
    }
    
    private func setTimer(isOn: Bool){
        if isOn{
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [unowned flowControlViewModel] (timer) in
                flowControlViewModel.fetchData()                
                debugPrint("fetch data")
            }
            timer?.fire()
        }else{
            timer?.invalidate()
        }
    }
    
    private func initView(){
        
        //tabarView
        let isFavoriteExist = flowControlViewModel.infos?.filter({ (viewMode) -> Bool in
            return viewMode.isFavorite == true
            }).count ?? 0 > 0
        let tabBarNames = isFavoriteExist ? ["列表", "地圖", "我的最愛"] : ["列表", "地圖"]
        var tabBarViewModels: [TabBarViewModel] = []
        for name in tabBarNames{
            let viewModel = TabBarViewModel(model: TabBarModel(title: name))
            tabBarViewModels.append(viewModel)
        }
        tabBarView = TabBarView(frame: .zero, viewModels: tabBarViewModels)
        self.view.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.tabBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tabBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tabBarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        //layout
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
         //collectionView
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.tabBarView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 0),
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //self.collectionView.alwaysBounceVertical = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = true
        self.collectionView.backgroundColor = .rgba(23, 28, 27, 1)
        
        //TODO: myFavoriteVC init if UserDefault exist
        viewcontrollers = [listVC, mapVC, myFavoriteVC]
        for vc in viewcontrollers{
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-80)
            self.views.append(vc.view)
            vc.didMove(toParent: self)
        }
        
        self.collectionView.reloadData()
        //NotificationCenter setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViews(notification:)), name: Notification.Name(rawValue: "didSelectMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideBar(notification:)), name: NSNotification.Name("hide"), object: nil)
        
        self.view.backgroundColor = UIColor.rgba(23, 28, 27, 1)
    }
    
    @objc func hideBar(notification: Notification){
        if let state = notification.object as? Bool{
            self.navigationController?.setNavigationBarHidden(state, animated: true)
        }
    }
    
}

extension FlowController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabBarView.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let vcView = self.views[indexPath.row]
        cell.contentView.addSubview(vcView)
        vcView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vcView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            vcView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
            vcView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            vcView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
        ])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK- : ui update behavior (include scroll)
extension FlowController{
    
    //MARK: 點擊上方tabbar
    @objc func scrollViews(notification: Notification){
        mapVC.userlocation = self.userLocation
        if let info = notification.userInfo as? [String: Int]{
            self.collectionView?.scrollToItem(at: IndexPath(row: info["index"] ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            //更新 我的最愛
            if info["index"] == 2{
                myFavoriteVC.viewModels = flowControlViewModel.infos?.filter{$0.isFavorite == true}
            }
        }
    }
    
    //MARK: scrollview 移動
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollIndex = scrollView.contentOffset.x / self.view.bounds.width
        debugPrint(scrollIndex)
        mapVC.userlocation = self.userLocation
        NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollMenu"), object: nil, userInfo: ["length": scrollIndex])
    }
    
    func updateFavoriteUI(){
        DispatchQueue.main.async {
            let favoriteAry = self.flowControlViewModel.infos?.filter({ (viewMode) -> Bool in
                return viewMode.isFavorite == true
            })
            let isFavoriteExist = favoriteAry?.count ?? 0 > 0
            let tabBarNames = isFavoriteExist ? ["列表", "地圖", "我的最愛"] : ["列表", "地圖"]
            var tabBarViewModels: [TabBarViewModel] = []
            for name in tabBarNames{
                let viewModel = TabBarViewModel(model: TabBarModel(title: name))
                tabBarViewModels.append(viewModel)
            }
            self.tabBarView.viewModels = tabBarViewModels
            self.collectionView.reloadData()
            
            if !isFavoriteExist{
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                self.tabBarView.moveToFirstIndicator()
            }
            self.myFavoriteVC.viewModels = favoriteAry
            self.listVC.tableView.reloadData()
        }
    }
}

extension FlowController: StationListPageViewControllerDelegate{
    
    func changedFavorite() {
        updateFavoriteUI()
    }
    
    func reloadData() {
        flowControlViewModel.fetchData()
        updateFavoriteUI()
    }
    
    func stationListPageViewControllerDidSelectStation(_ selectedStation: UBikeRentInfoViewModel) {
        let stationInMapPageViewController = StationInMapPageViewController()
        stationInMapPageViewController.isNeedIndicatorView = true
        self.presentVC(vc: stationInMapPageViewController)
        stationInMapPageViewController.singleStationViewModel = selectedStation
    }
    
    func presentVC(vc: UIViewController){
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            if let modalVC = window.rootViewController?.presentedViewController {
                modalVC.present(vc, animated: true, completion: nil)
            } else {
                window.rootViewController!.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
}
