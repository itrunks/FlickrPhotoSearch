//
//  JsonParameterEncoding.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder
{
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            urlRequest.httpBody = jsonAsData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil
            {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
        }catch {
            throw NetworkError.encodingFailed
        }
    }
}

public struct JSONStringParameterEncoder: ParameterEncoder
{
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    {
        let urlParams = parameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value as? String ?? "")"
        }).joined(separator: "&")
        
        urlRequest.httpBody = urlParams.data(using: String.Encoding.utf8)
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("text", forHTTPHeaderField: "Content-Type")
        }
    }
}

