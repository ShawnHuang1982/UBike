//
//  ApiHelper.swift
//  testUBike
//
//  Created by yu-syue huang on 2019/11/27.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import Foundation

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
