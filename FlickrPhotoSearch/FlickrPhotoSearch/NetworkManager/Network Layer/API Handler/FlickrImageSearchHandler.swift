//
//  ShipmentHandler.swift
//  Amil Freight
//
//  Created by Ashfauck on 3/22/19.
//  Copyright © 2019 Vagus. All rights reserved.
//

import Foundation

class FlickrImageSearchHandler {
    
    static func getPhotoList(_ searchText: String, pageNo: Int, completion: @escaping (Result<(Photos?)>) -> ())
    {
        Router<FlickrImageSearchEndPoint>().request(FlickrImageSearchEndPoint.photoList(searchText, pageNo: pageNo)) { result in
            
            switch result
            {
            case .Success(let data, let response):
                
                if let response = response as? HTTPURLResponse
                {
                    let results = response.verifyResponse()
                    
                    switch results
                    {
                    case .success:
                        
                        guard let responseData = data
                            else
                        {
                            completion(.Failure(.noData))
                            return
                        }
                        
                        do
                        {
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            
                            print(jsonData)
                            
                            let apiResponse = try JSONDecoder().decode(FlickrSearchResults.self, from: responseData)
                            
                            completion(.Success(apiResponse.photos))
                        }
                        catch
                        {
                            print(error)
                            completion(.Failure(NetworkResponse.unableToDecode))
                        }
                        
                    case .failure(_):
                        
                        completion(.Failure(NetworkResponse.requestFailed))
                    }
                }
                break
        case .Failure( _):
                completion(.Failure(.commonError))
                break
        case .Error(_):
                completion(.Failure(.commonError))
                break
            }
        }
        
    }
  
}
