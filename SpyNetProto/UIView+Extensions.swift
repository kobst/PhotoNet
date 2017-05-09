//
//  UIView+Extensions.swift
//  SpyNetProto
//
//  Created by Edward Han on 4/27/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit

extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
}
