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
    var font: UIFont = UIFont(name: "PingFangTC-Medium", size: 30) ?? UIFont.systemFont(ofSize: 30)
    var title: String
    var color: UIColor = .white
    
    init(model: TabBarModel) {
        self.title = model.title
    }
}
