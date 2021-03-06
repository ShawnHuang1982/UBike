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
    var indicatorWidthConstraint: NSLayoutConstraint!
    var viewModels: [TabBarViewModel] = []{
        didSet{
            DispatchQueue.main.async {
                self.updateIndicator(row: self.selectedIndex)
                self.collectionView.reloadData()
            }
        }
    }
    
    private var selectedIndex = 0
    
    //MARK: View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, viewModels: [TabBarViewModel]){
        self.init(frame: frame)
        self.viewModels = viewModels
        self.initView()
        
        ///reference: https://stackoverflow.com/questions/14020027/how-do-i-know-that-the-uicollectionview-has-been-loaded-completely
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            self.setIndicatorView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension TabBarView{
    
    //MARK: Methods
    func initView() {
        
        //layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        //layout.minimumInteritemSpacing = 0

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
        self.backgroundColor = .rgba(23, 28, 27, 1)
        self.collectionView.backgroundColor = .rgba(23, 28, 27, 1)

        NotificationCenter.default.addObserver(self, selector: #selector(self.animateMenu(notification:)), name: Notification.Name(rawValue: "scrollMenu"), object: nil)
        
        //indicatorView
        indicatorView = UIView()
        indicatorView.backgroundColor = .white
        self.addSubview(indicatorView)
    }
    
    func moveToFirstIndicator(){
        DispatchQueue.main.async {
            self.selectedIndex = 0
            self.updateIndicator(row: self.selectedIndex)
        }
    }
    
    @objc func animateMenu(notification: Notification) {
        if let info = notification.userInfo {
            let userInfo = info as! [String: CGFloat]
            self.selectedIndex = Int(round(userInfo["length"]!))
            //update indicator
            updateIndicator(row: selectedIndex)
            
            //update tab bar name
            if floor(userInfo["length"]!) == userInfo["length"]!{
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

        }
    }
    
    private func updateIndicator(row: Int){
        DispatchQueue.main.async {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: row, section: 0))
            let real = self.collectionView.convert(cell?.frame.origin ?? .zero, to: self.collectionView.superview)
            self.indicatorLeadingConstraint.constant = (real.x)
            self.indicatorWidthConstraint.constant = cell?.frame.width ?? 50.0
            self.layoutIfNeeded()
        }
    }
    
    private func setIndicatorView(){
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        let cell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0))
        indicatorLeadingConstraint = self.indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: cell?.frame.origin.x ?? .zero)
        indicatorWidthConstraint = self.indicatorView.widthAnchor.constraint(equalToConstant: cell?.frame.width ?? 50.0)
        indicatorLeadingConstraint.isActive = true
        indicatorWidthConstraint.isActive = true
        self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        self.indicatorView.layer.cornerRadius = 2
        self.indicatorView.clipsToBounds = true
    }
}


extension TabBarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TabBarCellCollectionViewCell
        setCell(viewModel: viewModels[indexPath.row], cell: cell, isSelected: indexPath.row == selectedIndex)
        return cell
    }
    
    private func setCell(viewModel: TabBarViewModel, cell: TabBarCellCollectionViewCell, isSelected: Bool){
        cell.viewModel = viewModel
        cell.titleLabel.textColor = isSelected ? viewModel.selectedColor : viewModel.color
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.row {
            self.selectedIndex = indexPath.row
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "didSelectMenu"), object: nil, userInfo: ["index": self.selectedIndex])
        }
    }
}
