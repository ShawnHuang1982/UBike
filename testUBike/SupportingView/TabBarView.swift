//
//  TabBarView.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/5.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class TabBarView: UIView {
    
    var collectionView: UICollectionView!
    var indicatorView: UIView!
    var indicatorLeadingConstraint: NSLayoutConstraint!
    var indicatorWidth: NSLayoutConstraint!
    var tabBarTitlesName: [String] = []
    
    var selectedIndex = 0
    
    //MARK: View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titles: [String]){
        self.init()
        self.tabBarTitlesName = titles
        self.collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension TabBarView{
    //MARK: Methods
    func initView() {
        
        //layout
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        //collectionView
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let nib = UINib(nibName: "TabBarCellCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.addSubview(collectionView)

        self.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    
        self.backgroundColor = UIColor.blue


        NotificationCenter.default.addObserver(self, selector: #selector(self.animateMenu(notification:)), name: Notification.Name.init(rawValue: "scrollMenu"), object: nil)
        
        indicatorView = UIView()
        self.addSubview(indicatorView)
    }
    
    @objc func animateMenu(notification: Notification) {
        if let info = notification.userInfo {
            let userInfo = info as! [String: CGFloat]
            //self.indicatorLeadingConstraint.constant = self.indicatorView.bounds.width * userInfo["length"]!
            self.selectedIndex = Int(round(userInfo["length"]!))
            self.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
}


extension TabBarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarTitlesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TabBarCellCollectionViewCell
        cell.titleLabel.text = tabBarTitlesName[indexPath.row]
        return cell
    }
    
    private func setCell(title: String?, cell: TabBarCellCollectionViewCell){
        //indicatorView.translatesAutoresizingMaskIntoConstraints = false
        //cell.titleLabel.centerXAnchor.constraint(equalTo: self.indicatorView.centerXAnchor).isActive = true
        //self.indicatorView.widthAnchor.constraint(equalToConstant: cell.titleLabel.frame.width + 10).isActive = true
        
        //let cellHeight: CGFloat = cell.titleLabel.frame.height + 5
        //self.indicatorView.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        
        //self.indicatorView.layer.cornerRadius = 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.row {
            self.selectedIndex = indexPath.row
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "didSelectMenu"), object: nil, userInfo: ["index": self.selectedIndex])
        }
    }
}
