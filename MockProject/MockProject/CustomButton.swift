//
//  CustomButton.swift
//  MockProject
//
//  Created by Datt-D1 on 3/19/19.
//  Copyright © 2019 Datt-D1. All rights reserved.
//

import UIKit

@IBDesignable
public class CustomButton: UIButton {
    @IBInspectable var colorOfButton: UIColor = UIColor.cyan {
        didSet {
            backgroundColor = colorOfButton
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        setButton()
    }
    
    func setButton() {
        
        clipsToBounds = true
        layer.cornerRadius = frame.height/2
        backgroundColor = colorOfButton
        layer.shadowOffset = CGSize(width: 0, height: 15)
        layer.shadowColor = UIColor.black.cgColor
        
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
}
