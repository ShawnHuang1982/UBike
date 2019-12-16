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
        label.textColor = UIColor.rgba(240, 243, 242, 1)
        label.font = UIFont(name: "PingFangTC-Medium", size: 17)
        return label
    }()
    
    /// eg. "忠孝東路/松仁路(東南側)"
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.rgba(178, 178, 178, 1)
        label.font = UIFont(name: "PingFangTC-Regular", size: 14)
        return label
    }()
    
    /// eg. "信義區"
    var sareaLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.rgba(77, 77, 77, 1)
        label.font = UIFont(name: "PingFangTC-Regular", size: 14)
        return label
    }()
    
    ///場站目前車輛數量/可借車位數
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC-Medium", size: 24)
        return label
    }()
    
    let lineView = UIView()
    
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
        setLabel(stationLabel, text: viewModel?.sna)
        setLabel(addressLabel, text: viewModel?.ar)
        setLabel(sareaLabel, text: viewModel?.sareaen)
        let number = displayNumberMode == .sbi ? viewModel?.sbi : viewModel?.bemp
        let color = displayNumberMode == .sbi ? viewModel?.sbiColor : viewModel?.bempColor
        setLabel(numberLabel, text: number, fontColor: color?.font)
        containerView.backgroundColor = color?.background
        
    }
    
    func initView(){
        setContainerView()
        setStationLabel()
        setAddressLabel()
        setSareaLabel()
        setNumberLabel(displayNumberMode: self.displayNumberMode ?? .sbi)
    }
    
    @objc func tapButton(){
        
    }
    
    private func setLabel(_ label:UILabel?, text:String?, fontColor: UIColor? = nil){
        UIView.animate(withDuration: 1) {
            label?.text = text
            label?.textColor = fontColor
        }
    }
    
    private func setLabel(_ label:UILabel?, text:String?){
        UIView.animate(withDuration: 1) {
            label?.text = text
        }
    }
    
    private func setContainerView(){
        self.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17).isActive = true

        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true

        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true

        containerView.backgroundColor = UIColor.rgba(36, 40, 40, 1)
        containerView.layer.cornerRadius = 10
        
    }
    
    private func setStationLabel(){
        
        self.containerView.addSubview(stationLabel)
        stationLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item:self.stationLabel , attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 12).isActive = true
        let _ = NSLayoutConstraint.init(item: self.stationLabel, attribute: .leading, relatedBy: .equal, toItem: self.containerView , attribute: .leading, multiplier: 1.0, constant: 16).isActive = true
        stationLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        lineView.backgroundColor = UIColor.rgba(23, 28, 27, 1)
        self.containerView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: lineView, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: lineView, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: lineView, attribute: .leading, relatedBy: .equal, toItem: stationLabel, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        //TODO: 我的最愛
//        let button = UIButton()
//        self.containerView.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
//        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        button.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 5).isActive = true
//        button.trailingAnchor.constraint(equalTo: self.lineView.leadingAnchor, constant: 20).isActive = true
//        button.setImage(UIImage(named: "favorite"), for: .normal)
        
        let supportTextLabel = UILabel()
        supportTextLabel.text = displayNumberMode == .sbi ? "可借" : "可還"
        supportTextLabel.textColor = UIColor.rgba(152, 152, 152, 1)
        supportTextLabel.font = UIFont(name: "PingFangTC-Regular", size: 14)
        supportTextLabel.textAlignment = .right
        self.containerView.addSubview(supportTextLabel)
        supportTextLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: supportTextLabel, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1.0, constant: 30).isActive = true
        
        let _ = NSLayoutConstraint.init(item: supportTextLabel, attribute: .leading, relatedBy: .equal, toItem: lineView, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        
        let _ = NSLayoutConstraint.init(item: supportTextLabel, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1.0, constant: -10).isActive = true
        supportTextLabel.heightAnchor.constraint(equalToConstant: 29).isActive = true

        
    }
    
    private func setAddressLabel(){
        self.containerView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.stationLabel, attribute: .bottom, relatedBy: .equal, toItem: self.addressLabel, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.addressLabel, attribute: .leading, relatedBy: .equal, toItem: self.stationLabel, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.addressLabel, attribute: .trailing, relatedBy: .equal, toItem: self.stationLabel, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
    }
    
    private func setSareaLabel(){
        self.containerView.addSubview(sareaLabel)
        sareaLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.addressLabel, attribute: .bottom, relatedBy: .equal, toItem: self.sareaLabel, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.sareaLabel, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.sareaLabel, attribute: .leading, relatedBy: .equal, toItem: self.stationLabel, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.sareaLabel, attribute: .trailing, relatedBy: .equal, toItem: self.stationLabel, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        
        sareaLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setNumberLabel(displayNumberMode: DisplayMode){

        let label1 = UILabel()
        label1.text = "輛"
        label1.textColor = UIColor.rgba(152, 152, 152, 1)
        label1.font = UIFont(name: "PingFangTC-Regular", size: 14)
        self.containerView.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: label1, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: label1, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1.0, constant: -9).isActive = true
        label1.widthAnchor.constraint(equalToConstant: 29).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.containerView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .trailing, relatedBy: .equal, toItem: label1, attribute: .leading, multiplier: 1.0, constant: -5).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .bottom, relatedBy: .equal, toItem: label1, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        let _ = NSLayoutConstraint.init(item: self.numberLabel, attribute: .leading, relatedBy: .equal, toItem: lineView, attribute: .trailing, multiplier: 1.0, constant: 10).isActive = true
        numberLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
