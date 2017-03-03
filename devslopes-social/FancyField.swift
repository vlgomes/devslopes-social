//
//  FancyField.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 03/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit

class FancyField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor (red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //the placheholder text appears a little to the right
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        //the text appears a little to the right
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
