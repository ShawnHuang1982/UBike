//
//  DataModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/9.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit


class InfomationViewModel {
    var iconName: String?
    var prefix: String?
    var description: String?
    var suffix: String?
    var descriptionFont: UIFont?
    var descriptionColor: UIColor?
    var defaultTextColor: UIColor?
    
    var reloadView: ((_ text:String?, _ textColor: UIColor?) -> Void)?
    
    init(iconName: String?, prefix: String?, description: String?, suffix: String?, descriptionFont: UIFont?, descriptionColor: UIColor?, defaultTextColor: UIColor?) {
        self.iconName = iconName
        self.prefix = prefix
        self.description = description
        self.suffix = suffix
        self.descriptionFont = descriptionFont
        self.descriptionColor = descriptionColor
        self.defaultTextColor = defaultTextColor
    }
}
