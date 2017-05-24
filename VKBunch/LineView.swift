//
//  LineView.swift
//  VKBunch
//
//  Created by Denis Shustin on 24.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit

class LineView: UIView {

  
    override func draw(_ rect: CGRect) {
        var aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x:80, y:80))
        
        aPath.addLine(to: CGPoint(x:220, y:110))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.black.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }

}
