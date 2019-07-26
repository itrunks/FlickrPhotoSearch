//
//  Router.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

 typealias NetworkRouterCompletion = (Result<(Data?,URLResponse?)>) -> ()


protocol NetworkRouter: class
{
    associatedtype EndPoint: RequestSchema
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    
    func cancel()
}

class Router<EndPoint: RequestSchema>: NetworkRouter {

    private var task: URLSessionTask?
    {
        didSet
        {
            guard let task = task else { return }
            
            DispatchQueue.main.async {
                if task.state == .running
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    {
       
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.waitsForConnectivity = true
        
        let session = URLSession(configuration: sessionConfig)
        
        do {
            let request = try self.buildRequest(from: route)
            
            // Log the response on the console
            //   AFNetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                NetworkLogger.log(response: response)
                
                if let err =  error{
                    completion(.Failure(err as! NetworkResponse))
                }
                
                let succ = (data, response)
                completion(.Success(succ))
            })
            
            self.task?.resume()
        }
        catch
        {
            completion(.Failure(error as! NetworkResponse))
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: URL(string:(route.baseURL + route.path + route.queryParam))!,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 30.0)
        print("===== \(request)")
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}
