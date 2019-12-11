//
//  TabBarCellCollectionViewCell.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/12/5.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class TabBarCellCollectionViewCell: UICollectionViewCell {

    var titleLabel: UILabel!
    var viewModel: TabBarViewModel!{
        didSet{
            self.titleLabel.text = viewModel.title
            self.titleLabel.font = viewModel.font
            self.titleLabel.textAlignment = .center
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }

}
