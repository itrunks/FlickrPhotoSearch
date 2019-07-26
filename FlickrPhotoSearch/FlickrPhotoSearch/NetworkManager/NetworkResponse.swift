//
//  NetworkResponse.swift
//  UbarFlickrSearchTask
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation

enum NetworkResponse:Error {
    case success
    case authenticationError
    case badRequest
    case notFound
    case outdated
    case requestFailed
    case noData
    case unableToDecode
    case networkFailed
    case commonError
    case noNotifications
    
    var detail:String {
        
        switch self {
        case .success:
            return "Success"
        case .authenticationError:
            return "You need to be authenticated first."
        case .badRequest:
            return  "Bad request"
        case .outdated:
            return "The url you requested is outdated."
        case .requestFailed:
            return "Network request failed."
        case .notFound:
            return "Not found"
        case .noData:
            return "Response returned with no data to decode."
        case .unableToDecode:
            return "We could not decode the response."
        case .networkFailed:
            return "Unable to connect to the internet"
        case .noNotifications:
            return "No Notifications"
        case .commonError:
            return self.localizedDescription
        }
        
    }
    
}

extension HTTPURLResponse
{
    func verifyResponse() -> ResponseCheck<String>
    {
        switch self.statusCode
        {
        case 200...299:
            return .success
        case 400:
            return .failure(NetworkResponse.badRequest.detail)
        case 404:
            return .failure(NetworkResponse.notFound.detail)
        case 401...500:
            return .failure(NetworkResponse.authenticationError.detail)
        case 501...599:
            return .failure(NetworkResponse.badRequest.detail)
        case 600:
            return .failure(NetworkResponse.outdated.detail)
        default:
            return .failure(NetworkResponse.commonError.detail)
        }
    }
}

enum ResponseCheck<String>
{
    case success
    case failure(String)
}

