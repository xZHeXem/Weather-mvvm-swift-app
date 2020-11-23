//
//  Network.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import Alamofire

class Network: NetworkProtocol {
    
    // MARK: - Variables
    private let cacher = ResponseCacher(behavior: .cache)
    
    // MARK: - Functions
    public func getRequest<T>(_ url: String, params: [String:String], headers: [String:String], responseHandler: @escaping (T?, Error?) -> Void ) -> NetworkRequest
                where T: Decodable {
        
        return AF.request(url,
                          method: .get,
                          parameters: params,
                          headers: HTTPHeaders( headers )
        )
        .cacheResponse(using: cacher)
        .responseDecodable { (dataResponse: DataResponse<T, AFError>) in
            
            if dataResponse.response?.statusCode ?? 200 != 200 {
                
                print(String.init(data: dataResponse.data!, encoding: .utf8) ?? "Unknown error \(dataResponse.response!.statusCode)" )
                return
            }
            
            if (dataResponse.error == nil ) {
                
                responseHandler(dataResponse.value, nil)
            } else {
                
                responseHandler(nil, dataResponse.error! as NSError)
            }
        }
    }
    
    
    public func cancelRequest(request: NetworkRequest) -> Bool {
        
        if let almoRequest = request as? Request {
            
            almoRequest.cancel()
            return true
        } else {
            
            return false
        }
    }
    
    public func isRequestWorking(request: NetworkRequest) -> Bool {
        
        if let almoRequest = request as? Request {
            
            return almoRequest.state == .initialized  || almoRequest.state == .suspended
        } else {
            
            return false
        }
    }
}
