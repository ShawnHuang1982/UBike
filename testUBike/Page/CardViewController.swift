//
//  CardViewController.swift
//  testUBike
//
//  Created by shawn on 2019/12/9.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//
protocol CardViewControllerDelegate: class {
    func selectedStation(station: UBikeRentInfoViewModel)
}
import UIKit

class CardViewController: UIViewController {

    let stackView: UIStackView = UIStackView()
    var navigationView: UIView = UIView()
    var info: [InfomationModel]?
    
    var singleStationViewModel: UBikeRentInfoViewModel?
    var listViewModel: [UBikeRentInfoViewModel]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    weak var delegate: CardViewControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .rgba(36, 40, 40, 1)
        tableView.register(ListInMapTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    private func initView(){
        debugPrint("👉initView")
        setStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.3) {
//            [weak self] in
//        }
    }
    
    private func setTableView(){
        self.stackView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    private func setNavigationToPlaceView(){
        navigationView.backgroundColor = .green
        self.stackView.addArrangedSubview(navigationView)
       
    navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //navigationView.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        //navigationView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 16).isActive = true
        //navigationView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 0).isActive = true
        navigationView.backgroundColor = .white
    }
    
    private func setListInfo(viewModel: UBikeRentInfoViewModel?){
        
    }
    
    private func setInfomationView(viewModel: UBikeRentInfoViewModel?){
        
        info = [InfomationModel(iconName: "icon_total", description: viewModel?.sna),
                InfomationModel(iconName: "icon_location", description: viewModel?.ar),
                InfomationModel(iconName: "icon_parking", description: viewModel?.tot), InfomationModel(iconName: "icon_rent_number", description: viewModel?.sbi), InfomationModel(iconName: "icon_time", description: viewModel?.bemp), InfomationModel(iconName: "icon_timeUp", description: viewModel?.mday)]
        guard let info = self.info else { return }
        var lastview: UIView!
        for (i,data) in info.enumerated(){
            if i == 0{
                lastview = setHeaderItemInfoView()
            }
            lastview = setSingleItemInfoView(lastView: lastview, icon: UIImage(named: "\(data.iconName ?? "")") , description: data.description ?? "下載中")
        }

    }
    
    private func setHeaderItemInfoView() -> UIView{
        let headerView = UIView()
        self.stackView.addArrangedSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    private func setSingleItemInfoView(lastView:UIView, icon: UIImage?, description: String) -> UIView{
        //add subview
        let infoItemView = UIView()
        let iconView = UIImageView(image: icon)
        infoItemView.addSubview(iconView)
        let descriptionLabel = UILabel()
        infoItemView.addSubview(descriptionLabel)
        self.stackView.addArrangedSubview(infoItemView)
        
        infoItemView.translatesAutoresizingMaskIntoConstraints = false
       infoItemView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        infoItemView.backgroundColor = .white

        //icon
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: infoItemView.leadingAnchor, constant: 0).isActive = true
        iconView.topAnchor.constraint(equalTo: infoItemView.topAnchor, constant: 0).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        //descriptionLabel
        descriptionLabel.text = description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: infoItemView.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0).isActive = true
        
        descriptionLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0).isActive = true
        return infoItemView
    }
    
    private func setStackView(){
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 1
        
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        stackView.addArrangedSubview(emptyView)
        
        setTableView()
        //setNavigationToPlaceView()
        //setInfomationView(viewModel: self.singleStationViewModel)

    }
}

extension CardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListInMapTableViewCell(viewModel: listViewModel?[indexPath.row], reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let station = listViewModel?[indexPath.row]{
            debugPrint("selected station= ", station)
            delegate?.selectedStation(station: station)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
