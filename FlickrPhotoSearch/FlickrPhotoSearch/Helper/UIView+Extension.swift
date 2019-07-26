//
//  UIViewController+Extension.swift
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

extension UIView {
    
    func showLoadingHUD()
    {
        DispatchQueue.main.async
            {
    guard (self.viewWithTag(-23232323) as? UIActivityIndicatorView) != nil else {
                    
                        
                    let  nvActivityLoader = UIActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 80)))
 
  
                    nvActivityLoader.center =  self.center
                    
                    
                    nvActivityLoader.color = .black
                    
                    nvActivityLoader.tag = -23232323
                    
                    self.addSubview(nvActivityLoader)
                    
                    nvActivityLoader.startAnimating()
                    
                    return
                }
                
        }
    }
    
    func hideLoadingHUD()
    {
        DispatchQueue.main.async
            {
                guard let nvActivityView = self.viewWithTag(-23232323) as? UIActivityIndicatorView
                    else
                {
                    return
                }
                
                nvActivityView.stopAnimating()
                
                nvActivityView.removeFromSuperview()
        }
    }
    
   static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
}