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
    
    var listVC: StationListPageViewController!
    var myFavoriteVC: MyFavoriteStationViewController!
    
    var tabBarView: TabBarView!
    var collectionView: UICollectionView!
    var viewcontrollers: [UIViewController] = []
    var views: [UIView] = []
    
    private var stationInMapPageViewController: StationInMapPageViewController?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        listViewModels.fetchData()
        listViewModels.refreshViewClosure = {
            [unowned self, unowned listViewModels] in
            //debugPrint(viewModels.infos?.first)
            self.viewModels = listViewModels.infos
            DispatchQueue.main.async {
                self.listVC.viewModels = self.viewModels
                //self.present(self.listVC, animated: false, completion: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initView(){
        
        //tabarView
        tabBarView = TabBarView(titles:  ["列表", "我的最愛"])
        self.view.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tabBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tabBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tabBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
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
        self.collectionView.backgroundColor = .systemPink
        self.listVC =  StationListPageViewController()
        self.myFavoriteVC = MyFavoriteStationViewController()

        viewcontrollers = [listVC, myFavoriteVC]
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
        
        self.view.backgroundColor = .black

        
    }
    
    @objc func scrollViews(notification: Notification){
        if let info = notification.userInfo as? [String: Int]{
            self.collectionView?.scrollToItem(at: IndexPath(row: info["index"] ?? 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func hideBar(notification: Notification){
        if let state = notification.object as? Bool{
            self.navigationController?.setNavigationBarHidden(state, animated: true)
        }
    }
    
}

extension FlowController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewcontrollers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.addSubview(self.views[indexPath.row])
        viewcontrollers[indexPath.row].didMove(toParent: self)
        cell.contentView.backgroundColor = .gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollIndex = scrollView.contentOffset.x / self.view.bounds.width
        debugPrint(scrollIndex)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollMenu"), object: nil, userInfo: ["length": scrollIndex])
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
