//
//  RequestTaskType.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum RequestTaskType {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
