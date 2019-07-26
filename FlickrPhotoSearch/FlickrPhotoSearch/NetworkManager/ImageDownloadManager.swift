//
//  ImageDownloadManager.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

typealias ImageClosure = (_ result: Result<UIImage>, _ url: String) -> Void


class ImageDownloadManager: NSObject {
    
    static let shared = ImageDownloadManager()
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [UIImageView: (url:String, image:ImageClosure, imageDownload:ImageDownloadOperation)]()
    
    private override init() {
        operationQueue.maxConcurrentOperationCount = 100
    }
    
    func addOperation(url: String, imageView: UIImageView, completion: @escaping ImageClosure) {
        
        if let image = DataCache.shared.getImageFromCache(key: url)  {
            
            completion(.Success(image), url)
            if  let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                result.imageDownload.cancel()
            }
            
        } else {
            
            if !checkOperationExists(with: url,completion: completion) {
                
                if let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                    result.imageDownload.cancel()
                }
                
                let newOperation = ImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                    
                    if let result = self.dictionaryBlocks[imageView] {
                        
                        if result.url == downloadedImageURL {
                            
                            if let image = image {
                                
                                DataCache.shared.saveImageToCache(key: downloadedImageURL, image: image)
                                result.image(.Success(image), downloadedImageURL)
                                
                                if let result = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    result.imageDownload.cancel()
                                }
                                
                            } else {
                                result.image(.Failure(NetworkResponse.notFound), downloadedImageURL)
                            }
                            
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                operationQueue.addOperation(newOperation)
            }
        }
    }
    
    func checkOperationExists(with url: String, completion: @escaping ImageClosure) -> Bool {
        
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        
        return false
    }
}
