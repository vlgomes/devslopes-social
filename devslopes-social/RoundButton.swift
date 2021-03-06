//
//  RoundButton.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 03/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //color of the shadow
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        //the opacity of the shadow
        layer.shadowOpacity = 0.8
        //how far it blurs out
        layer.shadowRadius = 5.0
        //how far it goes in height
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    //round the corners of the button
    override func layoutSubviews() {
        //this isn't in the awake from nib because the width of the button isn't available yet
        super.layoutSubviews()
        
        //perfect round button
        layer.cornerRadius = self.frame.width / 2
    }
}
