//
//  FaceView.swift
//  Happiness
//
//  Created by Emian on 2016-02-01.
//  Copyright © 2016 Catalyz. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) ->Double?
}

@IBDesignable
class FaceView: UIView {
    
    weak var dataSource : FaceViewDataSource?

    
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 0.90 {didSet { setNeedsDisplay()} }

    var faceCenter : CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min (bounds.size.width, bounds.size.height)/2 * scale
    }
    
    
    
    
    private struct Scaling {
        static let faceRadiusToEyeRadius : CGFloat = 15
        static let faceRadiusToEyeOffset : CGFloat = 3
        static let faceRadiusToEyeSeparation : CGFloat = 1.5
        static let faceRadiusToMouthHeight : CGFloat = 3
        static let faceRadiusToMouthWidth : CGFloat = 1
        static let faceRadiusToMouthOffset : CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func drawEye(whichEye: Eye) -> UIBezierPath {
        
        var eyeCenter = faceCenter
        let eyeRadius = faceRadius/Scaling.faceRadiusToEyeRadius
        let eyeRadiusVerticalOffset = faceRadius/Scaling.faceRadiusToEyeOffset
        let eyeRadiusHorizontalSeparation = faceRadius/Scaling.faceRadiusToEyeSeparation
        
        eyeCenter.y -= eyeRadiusVerticalOffset
        
        switch (whichEye){
        case .Left:  eyeCenter.x -= eyeRadiusHorizontalSeparation/2
        case .Right: eyeCenter.x += eyeRadiusHorizontalSeparation/2
        }
        
     let drawnEye = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: (CGFloat)(2*M_PI), clockwise: true)
        
        return drawnEye
    
    }
    
    private func drawSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.faceRadiusToMouthWidth
        let mouthHeight = faceRadius / Scaling.faceRadiusToMouthHeight
        let mouthVerticalOffset = faceRadius / Scaling.faceRadiusToMouthOffset
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let facepath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: (CGFloat)(2*M_PI), clockwise: true)
        facepath.lineWidth = lineWidth
        color.set()
        facepath.stroke()
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let rightEye = drawEye(.Left)
       let leftEye = drawEye(.Right)
        rightEye.lineWidth = lineWidth
        leftEye.lineWidth = lineWidth
        let mouth = drawSmile(smiliness)
        mouth.stroke()
        rightEye.stroke()
        leftEye.stroke()
        
        
    }
   
    func scale (gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
    }

}
