//
//  NetworkProtocol.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

protocol NetworkProtocol {
    // using for split request from others Any objects
    typealias NetworkRequest = Any
    
    func getRequest<T>(_ url: String, params: [String:String], headers: [String:String], responseHandler: @escaping (T?, Error?) -> Void ) -> NetworkRequest
            where T: Decodable
    
    @discardableResult
    func cancelRequest(request: NetworkRequest) -> Bool
    
    func isRequestWorking(request: NetworkRequest) -> Bool
    
}
