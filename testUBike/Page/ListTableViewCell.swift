//
//  ListTableViewCell.swift
//  testUBike
//
//  Created by shawn on 2019/12/6.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

enum DisplayMode {
    ///可借車位數
    case sbi
    ///可還車位數
    case bemp
}

class ListTableViewCell: UITableViewCell {

    var containerView: UIView = UIView()
    
    /// eg. 捷運市政府站(3號出口)
    var stationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    /// eg. "忠孝東路/松仁路(東南側)"
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    ///空位數量/可還車位數
    var bempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC-Medium", size: 30) ?? UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    ///場站目前車輛數量/可借車位數
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC-Medium", size: 30) ?? UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private var displayNumberMode: DisplayMode?
    
    ///viewModel
    var viewModel: UBikeRentInfoViewModel? {
        didSet{
            self.combineViewModel()
        }
    }
    
    init(viewModel: UBikeRentInfoViewModel?, displayMode: DisplayMode, reuseIdentifier: String?){
        self.viewModel = viewModel
        self.displayNumberMode = displayMode
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    func initialize(){
        initView()
        combineViewModel()
    }
    
    func combineViewModel(){
        self.backgroundColor = .clear
        setLabel(stationLabel, text: viewModel?.sna, fontColor: viewModel?.color?.font)
        setLabel(addressLabel, text: viewModel?.ar, fontColor: viewModel?.color?.font)
        setLabel(bempLabel, text: viewModel?.bemp, fontColor: viewModel?.color?.font)
        let number = displayNumberMode == .sbi ? viewModel?.sbi : viewModel?.bemp
        setLabel(numberLabel, text: number, fontColor: viewModel?.color?.font)
        containerView.backgroundColor = viewModel?.color?.background
        
    }
    
    private func setLabel(_ label:UILabel?, text:String?, fontColor: UIColor?){
        UIView.animate(withDuration: 1) {
            label?.text = text
            label?.textColor = fontColor
        }
    }
    
    func initView(){
        setContainerView()
        setStationLabel()
        setAddressLabel()
        setNumberLabel()
    }
    
    private func setContainerView(){
        self.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true

        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true

        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true

        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 10
        
    }
    
    private func setStationLabel(){
        self.containerView.addSubview(stationLabel)
        stationLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item:self.stationLabel , attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        let _ = NSLayoutConstraint.init(item: self.stationLabel, attribute: .leading, relatedBy: .equal, toItem: self.containerView , attribute: .leading, multiplier: 1.0, constant: 10).isActive = true
        let _ = NSLayoutConstraint.init(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.stationLabel, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        stationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setAddressLabel(){
        self.containerView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.stationLabel, attribute: .bottom, relatedBy: .equal, toItem: self.addressLabel, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.addressLabel, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.addressLabel, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1.0, constant: 10).isActive = true
        addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    private func setNumberLabel(){
        self.containerView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 10).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .leading, relatedBy: .equal, toItem: addressLabel, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        
        numberLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
