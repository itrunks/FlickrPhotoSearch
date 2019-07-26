//
//  NetworkLogger.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation

class NetworkLogger
{
    var methodStartTime = Date()
    static func log(request: URLRequest)
    {
        NetworkLogger().methodStartTime = Date()
        
        print("- - - - - - - START TIME : \(NetworkLogger().methodStartTime) - - - - - - -")
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        
        var headers:String = ""
        
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
            headers += #"""
            --header "\#(key): \#(value)" \
            """#
        }
        
        var bodyString:String = ""
        
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
            bodyString += #" "\#(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")" "#
        }
        
        print(logOutput)
        
        let curl = #"""
            curl --location --request \#(method) "\#(urlAsString)" \ \#(headers)
            --data \#(bodyString)
            """#
        print(curl)
    }
    
    static func log(response: URLResponse?)
    {
        guard response != nil else { return }
        let methodFinish = Date().timeIntervalSince(NetworkLogger().methodStartTime)
        print("- - - - - - - START TIME : \(NetworkLogger().methodStartTime) - - - - - - -")
        
        print("- - - - - - - END TIME : \(methodFinish) - - - - - - -")
    }
}
