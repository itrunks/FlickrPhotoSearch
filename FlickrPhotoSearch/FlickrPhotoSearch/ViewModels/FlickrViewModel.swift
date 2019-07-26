//
//  FlickrViewModel.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

class FlickrViewModel: NSObject {
    
    private(set) var photoArray = [FlickrPhoto]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var showAlert: ((String) -> Void)?
    var dataUpdated: (() -> Void)?
    
    //Mark: Reset the data through fetching to get new images based on new search text
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    
    //Mark: Get Flickr images based on search text
    private func fetchResults(completion:@escaping () -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FlickrSearchService().request(searchText, pageNo: pageNo) { (result) in
            
            FlickrUI.runOnMainThread {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch result {
                case .Success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf: result.photo)
                        self.dataUpdated?()
                    }
                    completion()
                case .Failure(let message):
                    self.showAlert?(message.detail)
                    completion()
                case .Error(let error):
                    if self.pageNo > 1 {
                        self.showAlert?(error.detail)
                    }
                    completion()
                }
            }
        }
    }
    
    //Pagnation has been working once scrollview reached 10 cell before of last cell
    func fetchNextPage(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            //End loop calling, reset the page no to work end loop scrolling
            pageNo = 1
            fetchResults {
                completion()
            }
        }
    }
}

