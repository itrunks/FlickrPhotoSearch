//
//  ImageModel.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

struct ImageModel {
    
    let imageURL: String
    
    init(withPhotos photo: FlickrPhoto) {
        imageURL = photo.imageURL
    }
}
