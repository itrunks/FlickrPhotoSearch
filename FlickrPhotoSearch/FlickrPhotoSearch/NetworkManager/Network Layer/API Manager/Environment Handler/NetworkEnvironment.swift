//
//  EnvironmentManager.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 25/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation

enum NetworkEnvironment
{
    case release
    case staging
    case test
    
}

struct EnvironmentManager
{
    #if Test
    // Test environment
    static let environment:NetworkEnvironment = .test
    #elseif Stage
    // Stage environment
    static let environment:NetworkEnvironment = .staging
    #else
    // Release environment
    static let environment:NetworkEnvironment = .release
    #endif
    
    static var accessToken:String = ""
    static var environmentBaseURL:String {
        
        switch EnvironmentManager.environment
        {
        case .release:
            return "https://api.flickr.com/"
        case .staging:
            return "https://api.flickr.com/"
        case .test:
            return "https://api.flickr.com/"
        }
        
    }
    
}
