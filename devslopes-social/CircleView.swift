//
//  CircleView.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 06/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    //round the corners of the image
    override func layoutSubviews() {
        //this isn't in the awake from nib because the width of the button isn't available yet
        super.layoutSubviews()
        
        //perfect round button
        layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
