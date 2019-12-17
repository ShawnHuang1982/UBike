//
//  InfomationViewController.swift
//  testUBike
//
//  Created by shawn on 2019/12/17.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit
import CoreLocation

class InfomationViewController: UIViewController {

    let stackView: UIStackView = UIStackView()
    var navigationView: UIView = UIView()
    var gestureView: UIView = UIView()
    lazy var infoItemView: UIStackView = UIStackView()
    var singleStationViewModel: UBikeRentInfoViewModel?
    
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
    
    private func setStackView(){
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        stackView.backgroundColor = .rgba(36, 40, 40, 1)

        //emptyView
        let emptyView = UIView()
        emptyView.backgroundColor = .rgba(36, 40, 40, 1)
        stackView.addArrangedSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //infomation
        setInfomationView(viewModel: self.singleStationViewModel)
        
        //emptyView
        let emptyView2 = UIView()
        emptyView2.backgroundColor = .rgba(36, 40, 40, 1)
        stackView.addArrangedSubview(emptyView2)

    }
    
    private func setInfomationView( viewModel: UBikeRentInfoViewModel?){
        
        let textColor: UIColor = .rgba(174, 174, 174, 1)
        
        var font: UIFont{
            get{
                let font = UIFont(name: "PingFangTC-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)
                return font
            }
        }
        
        let row1 = InfomationViewModel(iconName: "transfer", prefix: viewModel?.sna, description: "", suffix: "", descriptionFont: font, descriptionColor: textColor, defaultTextColor: textColor)
        let row2 = InfomationViewModel(iconName: "bike", prefix: "可借", description: viewModel?.sbi ?? "0", suffix: "輛", descriptionFont: font, descriptionColor: viewModel?.sbiColor?.font, defaultTextColor: textColor)
        let row3 = InfomationViewModel(iconName: "icon_parking", prefix: "可還", description: viewModel?.bemp ?? "0", suffix: "輛", descriptionFont: font, descriptionColor: viewModel?.bempColor?.font, defaultTextColor: textColor)
        let row4 = InfomationViewModel(iconName: "access_time", prefix: ((viewModel?.act ?? "0") == "1" ? "營運中" : "暫停營運"), description: "", suffix: "", descriptionFont: font, descriptionColor: textColor, defaultTextColor: textColor)
        let row5 = InfomationViewModel(iconName: "swap", prefix: "總停車格", description: viewModel?.tot, suffix: "", descriptionFont: font, descriptionColor: textColor, defaultTextColor: textColor)
        let row6 = InfomationViewModel(iconName: "total", prefix: "區域", description: viewModel?.sarea, suffix: "", descriptionFont: font, descriptionColor: textColor, defaultTextColor: textColor)
        let infos = [row1, row2, row3, row4, row5, row6]
        self.stackView.addArrangedSubview(infoItemView)
        infoItemView.translatesAutoresizingMaskIntoConstraints = false
        infoItemView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        infoItemView.axis = .vertical
        infoItemView.distribution = .fill
        infoItemView.alignment = .fill
        infoItemView.spacing = 10
                        
        for (i,data) in infos.enumerated(){
            let containerView = UIView()
            infoItemView.addArrangedSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.heightAnchor.constraint(equalToConstant: 42).isActive = true
            setSingleItemInfoView(containerView: containerView, icon: UIImage(named: "\(data.iconName ?? "")"), prefix: data.prefix ?? "", suffix: data.suffix ?? "", textColor: data.defaultTextColor , description: data.description ?? "下載中", descriptionColor: data.descriptionColor, font: data.descriptionFont, imageColor: .rgba(77, 77, 77, 1), viewModel: infos[i])
        }
        
        let emptyView = UIView()
        emptyView.backgroundColor = .rgba(36, 40, 40, 1)
        infoItemView.addArrangedSubview(emptyView)
        
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
        prefixLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        prefixLabel.font = font
        prefixLabel.textColor = textColor
        prefixLabel.backgroundColor = .clear
        prefixLabel.textAlignment = .right
        
        //descriptionLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: prefixLabel.trailingAnchor, constant: 20).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        suffixLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true
        suffixLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        suffixLabel.font = font
        suffixLabel.textColor = textColor
    }
    

}
