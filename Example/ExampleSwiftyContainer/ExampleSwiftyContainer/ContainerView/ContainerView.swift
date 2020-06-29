//
//  ContainerView.swift
//  ExampleSwiftyContainer
//
//  Created by linsaeng on 2020/06/29.
//  Copyright © 2020 linsaeng. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
}
