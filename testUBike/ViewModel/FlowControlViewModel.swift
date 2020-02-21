//
//  FlowControlViewModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/7.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import Foundation
import CoreLocation

class FlowControlViewModel {
    
    var refreshViewClosure: (()->Void)?
    
    let apiHelper = ApiHelper()
    
    var userLocation: CLLocation?
    
    var infos: [UBikeRentInfoViewModel]? {
        didSet{
            self.refreshViewClosure?()
        }
    }
    
    var sortedInfos: [UBikeRentInfoViewModel]?{
        get{
            //debugPrint("👉2 sortedInfosByDefault")
            return self.infos?.filter{$0.act == "1"}.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.sno > rhs.sno
            })
        }
    }
    
    
    var sortedInfosByLocation: [UBikeRentInfoViewModel]?{
        get{
            //debugPrint("👉1 sortedInfosByLocation")
            guard let usrLocation = self.userLocation else {
                //debugPrint("no user location")
                return nil
            }
            let newViewModels = self.infos?.compactMap({ (viewModel) -> UBikeRentInfoViewModel in
                var newViewModel = viewModel
                newViewModel.usrLocation = usrLocation
                return newViewModel
            })

            let sortedAry = newViewModels?.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.distance ?? 0 < rhs.distance ?? 0
            })
            return sortedAry
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
