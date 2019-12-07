//
//  FlowControlViewModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/7.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import Foundation

class FlowControlViewModel {
    
    var refreshViewClosure: (()->Void)?
    
    let apiHelper = ApiHelper()
    
    var infos: [UBikeRentInfoViewModel]? {
        didSet{
            self.refreshViewClosure?()
        }
    }
    
    var sortedInfos: [UBikeRentInfoViewModel]?{
        get{
            self.infos?.filter{$0.act == "1"}.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.sno < rhs.sno
            })
        }
    }
    
    func fetchData(){
        let urlString =  "https://tcgbusfs.blob.core.windows.net/blobyoubike/YouBikeTP.gz"
        
        apiHelper.fetchUbikeStatus(from: urlString) { [weak self] (result) in
            switch result{
            case .success(let model):
                //debugPrint(model?.retVal.values)
                self?.infos = model?.retVal.values.map({ (detail) -> UBikeRentInfoViewModel in
                    return UBikeRentInfoViewModel(model: detail)
                })
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    init() {
    }
}
