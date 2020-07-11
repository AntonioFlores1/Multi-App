//
//  CanvasView.swift
//  Multiplication App
//
//  Created by antonio  on 7/4/20.
//  Copyright © 2020 antonio . All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var lineColor: UIColor!
    var linewidth: CGFloat!
    var path: UIBezierPath!
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    override func layoutSubviews() {
        //Not draw on the edges
        self.clipsToBounds = true
        //Want to recongize one touch
        self.isMultipleTouchEnabled = false
        
        lineColor = UIColor.black
        linewidth = 4
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        first touch on screen
        let touch = touches.first
        
//        using location of first touch for starting Point
        startingPoint = touch?.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
//        creating my line
        path = UIBezierPath()
//        starting point of line
        path.move(to: startingPoint)
        
        path.addLine(to: touchPoint)
        
        startingPoint = touchPoint
         
        drawShapeLayer()
    }
    
    
    func drawShapeLayer() {
//        Drawing a line with the path since it wont show up on it's own
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = linewidth
        shapeLayer.fillColor = lineColor.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
        
    }
    
    func clearCanvas(){
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
