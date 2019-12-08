//
//  UBikeRentInfoViewModel.swift
//  testUBike
//
//  Created by shawn on 2019/12/7.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import UIKit

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
    
    enum SbiStatus{
        case almostEmpty
        case full
        case careful
        case invalid
    }
    
    var sbiStatus: SbiStatus?{
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
    
    var color: (font: UIColor, background: UIColor)?{
        get{
            switch sbiStatus{
            case .careful: return (font: UIColor.black, background: UIColor.yellow)
            case .almostEmpty: return (font: UIColor.white, background: UIColor.red)
            case .full: return (font: UIColor.black, background: UIColor.green)
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
