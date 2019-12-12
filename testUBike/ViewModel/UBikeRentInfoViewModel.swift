//
//  UBikeRentInfoViewModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/7.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit
import CoreLocation

struct UBikeRentInfoViewModel {
    
    ///站點代號
    var sno: String //"0001"
    ///場站區域(英文)
    var sareaen: String
    ///場站名稱(中文)
    var sna: String //"捷運市政府站(3號出口)"
    ///場站總停車格
    var tot: String // "180"
    ///場站目前車輛數量/可借車位數
    var sbi: String // "110",
    ///空位數量 /可還車位數
    var bemp: String //67
    ///地址(英文)
    var aren: String //The S.W. side of Road Zhongxiao East Road & Road Chung Yan.
    ///地址(中文)
    var ar: String //"忠孝東路/松仁路(東南側)"
    ///資料更新時間
    var mday: String //"20191127192321"
    ///全站禁用狀態/ 場站暫停營運
    var act: String //1
    ///緯度
    var lat: String //"25.0408578889"
    ///經度
    var lng: String // "121.567904444"
    
    var staLocation: CLLocation?{
        get{
            guard let lat = Double(self.lat) else { return nil }
            guard let lng = Double(self.lng) else { return nil }
            return CLLocation(latitude: lat, longitude: lng)
        }
    }
    
    var usrLocation: CLLocation?
    
    var distance: Int?{
        get{
            guard let usrLoc = usrLocation, let staLoc = self.staLocation else { return nil }
            let distance = usrLoc.distance(from: staLoc)
            return Int(distance)
        }
    }
    
    var distanceColor: UIColor?{
        get{
            guard let distance = self.distance else { return nil }
            if distance >= 1000{
                return UIColor.rgba(255, 110, 121, 1)
            }else if distance <= 200{
                return UIColor.rgba(0, 203, 169, 1)
            }else{
                return UIColor.rgba(250, 173, 23, 1)
            }
        }
    }
    
    enum RentStatus{
        case almostEmpty
        case full
        case careful
        case invalid
    }
    
    var sbiStatus: RentStatus?{
        get{
            guard let sbiNumber = Int(sbi), act == "1" else { return .invalid }
            switch sbiNumber {
            case let x where x == 0:
                return .almostEmpty
            case let x where x >= 20:
                return .full
            default:
                return .careful
            }
        }
    }
    
    var sbiColor: (font: UIColor, background: UIColor)?{
        get{
            switch sbiStatus{
            case .careful: return (font: UIColor.rgba(250, 173, 23, 1), background: UIColor.rgba(37, 40, 40, 1))
            case .almostEmpty: return (font: UIColor.rgba(255, 110, 121, 1), background: UIColor.rgba(37, 40, 40, 1))
            case .full: return (font: UIColor.rgba(0, 203, 169, 1), background: UIColor.rgba(37, 40, 40, 1))
            default:
                return (font: UIColor.darkGray, background: UIColor.lightGray)
            }
        }
    }
    
    var bempStatus: RentStatus?{
        get{
            guard let bempNumber = Int(bemp), act == "1" else { return .invalid }
            switch bempNumber {
            case let x where x == 0:
                return .almostEmpty
            case let x where x >= 20:
                return .full
            default:
                return .careful
            }
        }
    }
    
    var bempColor: (font: UIColor, background: UIColor)?{
        get{
            switch bempStatus{
            case .careful: return (font: UIColor.rgba(250, 173, 23, 1), background: UIColor.rgba(37, 40, 40, 1))
            case .almostEmpty: return (font: UIColor.rgba(255, 110, 121, 1), background: UIColor.rgba(37, 40, 40, 1))
            case .full: return (font: UIColor.rgba(0, 203, 169, 1), background: UIColor.rgba(37, 40, 40, 1))
            default:
                return (font: UIColor.darkGray, background: UIColor.lightGray)
            }
        }
    }

    init(model: StationDetail) {
        self.sareaen = model.sareaen
        self.sna = model.sna
        self.tot = model.tot
        self.sbi = model.sbi
        self.bemp = model.bemp
        self.aren = model.aren
        self.ar = model.ar
        self.act = model.act
        self.mday = model.mday
        self.sno = model.sno
        self.lat = model.lat
        self.lng = model.lng
    }
}
