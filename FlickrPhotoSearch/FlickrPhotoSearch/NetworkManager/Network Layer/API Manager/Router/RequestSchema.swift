//
//  RequestSchema.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation


protocol RequestSchema {
    var baseURL: String { get }
    var path: String { get }
    var queryParam: String {get}
    var httpMethod: HttpMethod { get }
    var task: RequestTaskType { get }
    //MARK: use for post data api request with apikey/token key
   // var headers: HTTPHeaders? { get }
}
