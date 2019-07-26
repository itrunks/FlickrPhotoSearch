//
//  FlickrUI.swift
//  FlickrPhotoSearch
//
//  Created by Raja on 26/07/19.
//  Copyright © 2019 Raja. All rights reserved.
//

import Foundation
import UIKit

class FlickrUI {
    
    static func runAsynch(closure: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            closure()
        }
    }
    
    static func runOnMainThread(closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
}
