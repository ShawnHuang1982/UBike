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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    private func initView(){
        self.view.backgroundColor = .white
        setStackView()
        setNavigationToPlaceView()
        setInfomationView(viewModel: self.viewModel)
    }
    
    private func setNavigationToPlaceView(){
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(navigationView)
        navigationView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        navigationView.topAnchor.constraint(equalTo: self.stackView.topAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 16).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 0).isActive = true
        navigationView.backgroundColor = .white
    }
    
    private func setInfomationView(viewModel: UBikeRentInfoViewModel?){
        
        info = [InfomationModel(iconName: "", description: ""),
                InfomationModel(iconName: "icon_total", description: viewModel?.sna),
                InfomationModel(iconName: "icon_location", description: viewModel?.ar),
                InfomationModel(iconName: "icon_parking", description: viewModel?.tot), InfomationModel(iconName: "icon_rent_number", description: viewModel?.sbi), InfomationModel(iconName: "icon_time", description: viewModel?.bemp), InfomationModel(iconName: "icon_timeUp", description: viewModel?.mday)]
        guard let info = self.info else { return }
        var lastview: UIView!
        for (i,data) in info.enumerated(){
            
            if i == 0{
                lastview = self.stackView
            }
            let infoItemView = setSingleItemInfoView(lastView: lastview, icon: UIImage(named: "\(data.iconName ?? "")") , description: data.description ?? "下載中")
            lastview = infoItemView
            
        }

    }
    
    private func setSingleItemInfoView(lastView:UIView, icon: UIImage?, description: String) -> UIView{
        let infoItemView = UIView()
        self.stackView.addArrangedSubview(infoItemView)
        infoItemView.translatesAutoresizingMaskIntoConstraints = false
            infoItemView.leadingAnchor.constraint(equalTo: lastView.leadingAnchor, constant: 0).isActive = true
              
        infoItemView.trailingAnchor.constraint(equalTo: lastView.trailingAnchor, constant: 0).isActive = true
        
       infoItemView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        //icon
        let iconView = UIImageView(image: icon)
        infoItemView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.leadingAnchor.constraint(equalTo: infoItemView.leadingAnchor, constant: 0).isActive = true
        iconView.topAnchor.constraint(equalTo: infoItemView.topAnchor, constant: 0).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
                //descriptionLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        infoItemView.addSubview(descriptionLabel)
       
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: infoItemView.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0).isActive = true
       
        descriptionLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0).isActive = true
        
        return infoItemView
    }
    
    private func setStackView(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 1
    }
}
