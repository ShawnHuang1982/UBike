//
//  CardViewController.swift
//  testUBike
//
//  Created by shawn on 2019/12/9.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    let stackView: UIStackView = UIStackView()
    var navigationView: UIView = UIView()
    var info: [InfomationModel]?
    
    var viewModel: UBikeRentInfoViewModel?
    var isShowCardAsChild: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }

    private func initView(){
        debugPrint("👉initView")
        //self.view.backgroundColor = .green
        setStackView()
        setNavigationToPlaceView()
        setInfomationView(viewModel: self.viewModel)
    }
    
    override func updateViewConstraints() {
        
        guard isShowCardAsChild else {
            super.updateViewConstraints()
            
            return
        }
        debugPrint("👉updateViewConstraints")
        
        // distance to top introduced in iOS 13 for modal controllers
        // they're now "cards"
        let TOP_CARD_DISTANCE: CGFloat = 400.0
        
        // calculate height of everything inside that stackview
        var height: CGFloat = 0.0
        for v in self.stackView.subviews {
            height = height + v.frame.size.height
        }
        
        // change size of Viewcontroller's view to that height
        self.view.frame.size.height = height
        // reposition the view (if not it will be near the top)
        self.view.frame.origin.y = UIScreen.main.bounds.height - height - TOP_CARD_DISTANCE
        // apply corner radius only to top corners
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        super.updateViewConstraints()
    }
    
    private func setNavigationToPlaceView(){
        
        self.stackView.addArrangedSubview(navigationView)
        
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationView.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        //navigationView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 16).isActive = true
        //navigationView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 0).isActive = true
        navigationView.backgroundColor = .white
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
    }
}
