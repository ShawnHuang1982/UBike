//
//  StationListPageViewController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/2.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

protocol StationListPageViewControllerDelegate: class {
    ///選取站點
    func stationListPageViewControllerDidSelectStation(_ selectedStation: UBikeRentInfoViewModel)
    /// when 下拉更新
    func reloadData()
    /// 選取/取消選取我的最愛
    func changedFavorite()
}

class StationListPageViewController: UIViewController {
    
    var viewModels: [UBikeRentInfoViewModel]?{
        didSet{
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        return tableView
    }()
        
    lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["借車", "還車"])
        segment.tintColor = UIColor.white
        segment.backgroundColor = .rgba(77, 77, 77, 1)//.rgba(23, 28, 27, 1)
        return segment
    }()
    
    ///給上拉刷新提示用
    var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullRefreshData(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .gray
        return refreshControl
    }()
    
    @objc func pullRefreshData(_ sender:UIRefreshControl){
        delegate?.reloadData()
    }
    
    private var selectedIndexPath: IndexPath?
    
    weak var delegate: StationListPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setLongPressPreview()
    }
    
    private func initView(){
        setSegment()
        setTableView()
        self.view.backgroundColor = UIColor.rgba(23, 28, 27, 1)
        
        if self.refreshControl.isRefreshing
        {
            let offset = self.tableView.contentOffset
            self.refreshControl.endRefreshing()
            self.refreshControl.beginRefreshing()
            self.tableView.contentOffset = offset
        }
    }
    
    @objc func tapSegemnt(){
        tableView.reloadData()
    }
        
    private func setSegment(){
        self.view.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false
       
        segment.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10 ).isActive = true
        segment.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17).isActive = true
        segment.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -17).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        segment.selectedSegmentIndex = 0
        
        segment.addTarget(self, action: #selector(tapSegemnt), for: .valueChanged)
        
    }
    
    private func setTableView(){
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        tableView.backgroundColor = .rgba(23, 28, 27, 1)
        
        tableView.addSubview(self.refreshControl)
    }


}

extension StationListPageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayModel = segment.selectedSegmentIndex == 0 ? DisplayMode.sbi : DisplayMode.bemp
        let cell = ListTableViewCell(viewModel: viewModels?[indexPath.row], displayMode: displayModel, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        cell.callback = { [weak self] in
            //set favorite
            let sno = self?.viewModels?[indexPath.row].sno ?? ""
            let isFavorite = self?.viewModels?[indexPath.row].isFavorite ?? false
            UserDefaults.standard.set(!isFavorite, forKey: sno)
            
            //notify flowController
            self?.delegate?.changedFavorite()
            
        }
        return cell
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let station = viewModels?[indexPath.row]{
            delegate?.stationListPageViewControllerDidSelectStation(station)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         // Get current state from data source
        guard let viewModel = viewModels?[indexPath.row], let favorite = viewModel.isFavorite else {
           return nil
         }

         let title = favorite ?
           NSLocalizedString("Unfavorite", comment: "Unfavorite") :
           NSLocalizedString("Favorite", comment: "Favorite")

        let action = UIContextualAction(style: .normal, title: title,
                                        handler: { (action, view, completionHandler) in
            // Update data source when user taps action
            UserDefaults.standard.set(!favorite, forKey: (viewModel.sno))
                                            completionHandler(true)
        })

         action.image = UIImage(named: "favorite")
         action.backgroundColor = favorite ? .red : .orange
         let configuration = UISwipeActionsConfiguration(actions: [action])
         return configuration
    }
    
}


extension StationListPageViewController: UIViewControllerPreviewingDelegate{

    func setLongPressPreview(){
        registerForPreviewing(with: self, sourceView: self.view)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRow(at: location), let viewModel = viewModels?[indexPath.row] {
            selectedIndexPath = indexPath
            let infomationVC = InfomationViewController()
            infomationVC.singleStationViewModel = viewModel
            infomationVC.preferredContentSize = CGSize(width: 0.0, height: 450)
            return infomationVC
        }
        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        guard let row = selectedIndexPath?.row, let viewModel = self.viewModels?[row] else{
            return
        }
        delegate?.stationListPageViewControllerDidSelectStation(viewModel)
    }
}
