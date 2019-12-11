//
//  TabBarViewModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/7.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

struct TabBarModel {
    var title: String
}

struct TabBarViewModel {
    var font: UIFont = UIFont(name: "PingFangTC-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)
    var title: String
    var color: UIColor = UIColor.rgba(77, 77, 77, 1)
    var selectedColor: UIColor = .white
    
    init(model: TabBarModel) {
        self.title = model.title
    }
}
