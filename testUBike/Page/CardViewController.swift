//
//  CardViewController.swift
//  testUBike
//
//  Created by shawn on 2019/12/9.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//
protocol CardViewControllerDelegate: class {
    func selectedStation(station: UBikeRentInfoViewModel)
    func panGesture(originHeight: CGFloat, offsetY: CGFloat)
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
            case .scrollable(.card): return 350
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
    lazy var infoItemView: UIStackView = UIStackView()
    private var info: [InfomationViewModel]?
    private var bind1:((String?, UIColor?) -> Void)!
    private var bind2:((String?, UIColor?) -> Void)!
    private var bind3:((String?, UIColor?) -> Void)!

    var displayType: CardMode = .fixedHeight(.list)
    
    var singleStationViewModel: UBikeRentInfoViewModel?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.bind1(self.singleStationViewModel?.bemp, self.singleStationViewModel?.bempColor?.font)
                self.bind2(self.singleStationViewModel?.sbi, self.singleStationViewModel?.sbiColor?.font)
                self.bind3("", self.singleStationViewModel?.defaultFontColor)
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
    private var tableViewHeight: NSLayoutConstraint!
    
    lazy var originHeight: CGFloat = .zero
    
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
        if recognizer.state == .began{
            originHeight = self.view.frame.size.height
        }
        let translation = recognizer.translation(in: self.view)
        delegate?.panGesture(originHeight: self.originHeight, offsetY: translation.y)
    }
    
    private func setTableView(){
        self.stackView.addArrangedSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 350)
        tableViewHeight.isActive = true
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
    
    private func setInfomationView( viewModel: UBikeRentInfoViewModel?){
        
        let textColor: UIColor = .rgba(174, 174, 174, 1)
        let row1 = InfomationViewModel(iconName: "bike", prefix: "可借", description: "0", suffix: "輛", descriptionFont: viewModel?.font, descriptionColor: textColor, defaultTextColor: textColor)
        let row2 = InfomationViewModel(iconName: "icon_parking", prefix: "可還", description: "0", suffix: "輛", descriptionFont: viewModel?.font, descriptionColor: textColor, defaultTextColor: textColor)
        let row3 = InfomationViewModel(iconName: "access_time", prefix: "下載中", description: "", suffix: "", descriptionFont: viewModel?.font, descriptionColor: textColor, defaultTextColor: textColor)
        info = [row1, row2, row3]
        self.stackView.addArrangedSubview(infoItemView)
        infoItemView.translatesAutoresizingMaskIntoConstraints = false
        infoItemView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        infoItemView.axis = .vertical
        infoItemView.distribution = .fill
        infoItemView.alignment = .fill
        infoItemView.spacing = 10
                
        let lineView = UIView()
        infoItemView.addArrangedSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .rgba(23, 28, 27, 1)
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        guard let info = self.info else { return }
        for (i,data) in info.enumerated(){
            let containerView = UIView()
            infoItemView.addArrangedSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            setSingleItemInfoView(containerView: containerView, icon: UIImage(named: "\(data.iconName ?? "")"), prefix: data.prefix ?? "", suffix: data.suffix ?? "", textColor: data.defaultTextColor , description: data.description ?? "下載中", descriptionColor: data.descriptionColor, font: data.descriptionFont, imageColor: .rgba(77, 77, 77, 1), viewModel: info[i])
        }
        
        let emptyView = UIView()
        emptyView.backgroundColor = .rgba(36, 40, 40, 1)
        infoItemView.addArrangedSubview(emptyView)
        
        setBind()
        
    }

    func setSingleItemInfoView(containerView: UIView, icon: UIImage?, prefix:String, suffix:String, textColor: UIColor?, description: String, descriptionColor: UIColor?, font: UIFont?, imageColor: UIColor?, viewModel: InfomationViewModel?) {
        //add subview
        let iconView = UIImageView(image: icon)
        containerView.addSubview(iconView)
        let descriptionLabel = UILabel()
        containerView.addSubview(descriptionLabel)
        let prefixLabel = UILabel()
        containerView.addSubview(prefixLabel)
        let suffixLabel = UILabel()
        containerView.addSubview(suffixLabel)
        
        //icon
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 27).isActive = true
        iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iconView.setImageColor(color: imageColor ?? .white)
        
        //prefix
        prefixLabel.translatesAutoresizingMaskIntoConstraints = false
        prefixLabel.text = prefix
        prefixLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20).isActive = true
        prefixLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        prefixLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        prefixLabel.font = font
        prefixLabel.textColor = textColor
        prefixLabel.backgroundColor = .clear
        prefixLabel.textAlignment = .right
        
        //descriptionLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: prefixLabel.trailingAnchor, constant: 20).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descriptionLabel.text = description
        descriptionLabel.font = font
        descriptionLabel.textColor = descriptionColor
        viewModel?.reloadView = { text, textColor in
            DispatchQueue.main.async {
                descriptionLabel.text = text
                descriptionLabel.textColor = textColor
            }
        }
        
        //suffix
        suffixLabel.translatesAutoresizingMaskIntoConstraints = false
        suffixLabel.text = suffix
        suffixLabel.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 20).isActive = true
        suffixLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        suffixLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0).isActive = true
        suffixLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true
        suffixLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        suffixLabel.font = font
        suffixLabel.textColor = textColor
        
        var textChanged : (String) -> () = { _ in }
        
        func bind(callback:@escaping (String)->() ){
            textChanged = callback
        }

    }
    
    private func setStackView(){
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        stackViewHeight = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350)
        stackViewHeight.isActive = true

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        stackView.backgroundColor = .rgba(36, 40, 40, 1)
        setScrollIndicator()
        setTableView()
        setInfomationView(viewModel: self.singleStationViewModel)
        let emptyView = UIView()
        emptyView.backgroundColor = .rgba(36, 40, 40, 1)
        //emptyView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(emptyView)

        //setNavigationToPlaceView()

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
            stackViewHeight.constant = 380
            tableViewHeight.constant  = 350
            gestureView.isHidden = true
            infoItemView.isHidden = true
        case .scrollable(.card):
            stackViewHeight.constant = 200
            tableViewHeight.constant  = 105
            gestureView.isHidden = false
            infoItemView.isHidden = false
        default:
            tableView.isHidden = false
            gestureView.isHidden = false
        }
    }
    
    private func setBind(){
        bind1 = info?.first?.reloadView!
        bind2 = info?[1].reloadView!
        bind3 = info?[2].reloadView!
    }

    

    
    
    
}
