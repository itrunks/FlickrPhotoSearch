//
//  FlickrSearchService.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
/*
Except where otherwise noted in the source code (e.g. the files hash.c,
list.c and the trio files, which are covered by a similar licence but
with different Copyright notices) all the files are:

Copyright (C) 2019 Raja Pitchai.  All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is fur-
nished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FIT-
NESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
RAJA PITCHAI BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CON-
NECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of Raja Pitchai shall not
be used in advertising or otherwise to promote the sale, use or other deal-
ings in this Software without prior written authorization from him.
*/

import Foundation
import UIKit

class FlickrSearchService: NSObject {
    
    /// Flickr API Call using the "flickr.photos.search" method, to retrieve photos based on search text from a given page
    ///
    /// - Parameters:
    ///   - text: search term
    ///   - page: which page
    ///   - completion: completion handler to retrieve result
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let request = FlickrRequestConfig.searchRequest(searchText, pageNo).value else {
            return
        }
        
        NetworkManager.shared.request(request) { (result) in
            switch result {
            case .Success(let responseData):
                if let model = self.processResponse(responseData) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.Success(model.photos))
                    } else {
                        return completion(.Failure(NetworkResponse.unableToDecode))
                    }
                } else {
                    return completion(.Failure(NetworkResponse.networkFailed))
                }
            case .Failure(let message):
                return completion(.Failure(message))
            case .Error(let error):
                return completion(.Failure(error))
            }
        }
    }
    
    /// FlickrSearchResults model save success data, to retrieve photos based on search text from a given page
    ///
    /// - Parameters:
    ///   - data: decode the json data to return FlickrSearchResults model

    func processResponse(_ data: Data) -> FlickrSearchResults? {
        do {
            let responseModel = try JSONDecoder().decode(FlickrSearchResults.self, from: data)
            return responseModel
            
        } catch {
           // print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}
