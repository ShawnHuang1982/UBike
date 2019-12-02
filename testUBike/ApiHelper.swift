//
//  ApiHelper.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/11/27.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import Foundation


///ref: http://www-ws.gov.taipei/001/Upload/public/mmo/dot/YouBike_JSON檔案說明(修正版)_局網.pdf
    
struct UBikeStatusDataModel: Decodable {
    var retVal: [String : StationDetail]
}

enum DecodingError: Error {
    case missingParamKey
    case unrecognizedParamValue(String)
}

struct StationDetail: Decodable {
    ///站點代號
    var sno: String //"0001"
    ///場站名稱(中文)
    var sna: String //"捷運市政府站(3號出口)"
    ///場站總停車格
    var tot: String // "180"
    ///場站目前車輛數量/可借車位數
    var sbi: String // "110",
    ///場站區域(中文)
    var sarea: String //"信義區"
    ///資料更新時間
    var mday: String //"20191127192321"
    ///緯度
    var lat: String //"25.0408578889"
    ///經度
    var lng: String // "121.567904444"
    ///地址(中文)
    var ar: String //"忠孝東路/松仁路(東南側)"
    ///場站區域(英文)
    var sareaen: String //"Xinyi Dist."
    ///場站名稱(英文)
    var snaen: String //MRT Taipei City Hall Stataion(Exit 3)-2
    ///地址(英文)
    var aren: String //The S.W. side of Road Zhongxiao East Road & Road Chung Yan.
    ///空位數量 /可還車位數
    var bemp: String //67
    ///全站禁用狀態/ 場站暫停營運
    var act: String //1
}

struct UBikeRentInfoViewModel {
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
    var dateTime: Date

    init(model: StationDetail) {
        self.sareaen = model.sareaen
        self.sna = model.sna
        self.tot = model.tot
        self.sbi = model.sbi
        self.bemp = model.bemp
        self.aren = model.aren
        self.dateTime = Date()
    }
}

class ListViewModel {
    
    var refreshViewClosure: (()->Void)?
    
    let apiHelper = ApiHelper()
    
    var infos:[UBikeRentInfoViewModel]? {
        didSet{
            self.refreshViewClosure?()
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

enum NetworkError: Error {
    case domainError
    case decodingError
    case other(Error?)
}

class ApiHelper{
    
    let session:URLSession = URLSession.shared
    
    //TODO: Mock If needed
    //init(withSession session:) {
        
    //}
    
    func fetchUbikeStatus(from:String, _ completion: @escaping(Result<UBikeStatusDataModel?, NetworkError>) -> Void){
        
        guard let url = URL(string: from) else{
            completion(.failure(.domainError))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.other(error)))
                return
            }
            
            guard let result = data else{
                completion(.success(nil))
                return
            }
            
            do{
                let model = try JSONDecoder().decode(UBikeStatusDataModel.self, from: result)
                completion(.success(model))
            }catch{
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}
