//
//  TabBarCellCollectionViewCell.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/5.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class TabBarCellCollectionViewCell: UICollectionViewCell {

    var titleName: String!
    var titleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true

        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        titleLabel.textColor = .white
        titleLabel.text = titleName
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 30)
    }
    
    override func prepareForReuse() {
        titleLabel.text = titleName
    }

}
