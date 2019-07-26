//
//  Result.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

enum Result <T>{
    case Success(T)
    case Failure(NetworkResponse)
    case Error(NetworkResponse)
}
