//
//  ViewController.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/11/27.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModels = ListViewModel()
        viewModels.fetchData()
        viewModels.refreshViewClosure = {
            debugPrint(viewModels.infos?.first)
        }
        // Do any additional setup after loading the view.
    }


}

