//
//  StationListPageViewController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/2.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

protocol StationListPageViewControllerDelegate: class {
    func stationListPageViewControllerDidSelectStation(_ selectedStation: UBikeRentInfoViewModel)
}

class StationListPageViewController: UIViewController {

    let listViewModels = ListViewModel()
    
    var viewModels: [UBikeRentInfoViewModel]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    weak var delegate: StationListPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        listViewModels.fetchData()
        listViewModels.refreshViewClosure = {
            [unowned self, unowned listViewModels] in
            //debugPrint(viewModels.infos?.first)
            self.viewModels = listViewModels.infos
        }
        
        self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
    }
    
    private func setTableView(){
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(tableView)
    }

}

extension StationListPageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModels?[indexPath.row].sna
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
    
}
