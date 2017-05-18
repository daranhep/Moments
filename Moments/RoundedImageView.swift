//
//  RoundedImageView.swift
//  Moments
//
//  Created by Dara Nhep on 5/18/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.bounds.width / 2.0
        self.clipsToBounds = true
    }
    
}
