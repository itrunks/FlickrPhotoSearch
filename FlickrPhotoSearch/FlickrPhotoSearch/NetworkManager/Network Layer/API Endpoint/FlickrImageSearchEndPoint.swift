//
//  ShipmentEndPoint.swift
//  Amil Freight
//
//  Created by Ashfauck on 3/22/19.
//  Copyright © 2019 Vagus. All rights reserved.
//

import Foundation

enum FlickrImageSearchEndPoint {
    case photoList(_ searchText: String, pageNo: Int)
}

extension FlickrImageSearchEndPoint: RequestSchema
{
    
    var baseURL: String {
        let url =  EnvironmentManager.environmentBaseURL
        return url
    }
    
    var path: String {
        
        switch self{
        case .photoList(_, _):
                return "services/rest/"
        }
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var queryParam: String {
        switch self {
        case .photoList(let searchText, let pageNo):
              
              let methodPath = "method=flickr.photos.search"
              let apiKey = "api_key=\(FlickrConstants.api_key)"
              let format = "format=\(Response.json)"
              let callback = "nojsoncallback=1"
              let search = "safe_search=1"
              let perPage = "per_page=\(FlickrConstants.per_page)"
              let text = "text=\(searchText)"
              let page = "page=\(pageNo)"

              let queryPath =  "?" + methodPath + "&" + apiKey + "&" + format + "&" + callback + "&" + search + "&" + perPage + "&" + text + "&" + page
              return queryPath
        }
    }
    
    var task: RequestTaskType {
        switch self {
        case .photoList(_, _):
            return .request
    }
    
}

}
