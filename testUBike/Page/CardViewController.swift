//
//  CardViewController.swift
//  testUBike
//
//  Created by shawn on 2019/12/9.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//
protocol CardViewControllerDelegate: class {
    func selectedStation(station: UBikeRentInfoViewModel)
    func panGesture(offsetY: CGFloat)
}

enum CardMode: Equatable {
    
    enum type{
        case list
        case card
    }
    
    case fixedHeight(type)
    case scrollable(type)
    
    var contentHeight: CGFloat {
        get{
            switch self {
            case .fixedHeight(.list): return 380
            case .scrollable(.card): return 200
            default: return 100
            }
        }
    }
}

import UIKit

class CardViewController: UIViewController {

    let stackView: UIStackView = UIStackView()
    var navigationView: UIView = UIView()
    var gestureView: UIView = UIView()
    var info: [InfomationModel]?
    
    var displayType: CardMode = .fixedHeight(.list)
    
    var singleStationViewModel: UBikeRentInfoViewModel?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
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
        tableView.register(ListInMapTableViewCell.self, forCellReuseIdentifier: "ListCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var stackViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    private func initView(){
        debugPrint("👉initView")
        self.view.backgroundColor = .rgba(36, 40, 40, 1)
        setStackView()
    }
    
    private func setScrollIndicator(){
        self.stackView.addArrangedSubview(self.gestureView)
        gestureView.backgroundColor = .rgba(36, 40, 40, 1)
        gestureView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        let indicator = UIView()
        gestureView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: self.gestureView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.gestureView.centerYAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 26).isActive = true
        indicator.backgroundColor = .rgba(77, 77, 77, 1)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
         gestureView.addGestureRecognizer(gesture)
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        delegate?.panGesture(offsetY: translation.y)
    }
    
    private func setTableView(){
        self.stackView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        stackViewHeight = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350)
        stackViewHeight.isActive = true

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        let emptyView = UIView()
        emptyView.backgroundColor = .rgba(36, 40, 40, 1)
        emptyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(emptyView)
        stackView.backgroundColor = .rgba(36, 40, 40, 1)
        setScrollIndicator()
        setTableView()
        //setNavigationToPlaceView()
        //setInfomationView(viewModel: self.singleStationViewModel)

    }
}

extension CardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = displayType == .fixedHeight(.list) ? listViewModel?[indexPath.row] : singleStationViewModel
        let cell = ListInMapTableViewCell(viewModel: viewModel, reuseIdentifier: "ListCell")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (displayType == CardMode.fixedHeight(.list)) ? (listViewModel?.count ?? 0 ) : 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewModel = displayType == .fixedHeight(.list) ? listViewModel?[indexPath.row] : singleStationViewModel
        
        if let station = viewModel {
            debugPrint("selected station= ", station)
            delegate?.selectedStation(station: station)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension CardViewController {
    func selectMode( mode: CardMode){
        self.displayType = mode
        switch mode {
        case .fixedHeight(.list):
            stackViewHeight.constant = 350
            gestureView.isHidden = true
        case .scrollable(.card):
            stackViewHeight.constant = 200
            gestureView.isHidden = false
        default:
            tableView.isHidden = false
            gestureView.isHidden = false
        }
    }
    
}
