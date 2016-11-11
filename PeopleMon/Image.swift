//
//  Image.swift
//  PeopleMon
//
//  Created by Christopher Stanley on 11/10/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    func setupView(size: CGFloat) {
        let height = size / 2.0
        let width = size / 2.0
        self.layer.cornerRadius = min(height,width)
        self.clipsToBounds = true
    }
}
