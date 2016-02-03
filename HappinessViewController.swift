//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Emian on 2016-02-01.
//  Copyright © 2016 Catalyz. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:"pan:"))
            
        }
    }
    private struct Constant{
       static var happinessPanScale: CGFloat = 4.0
    }
    

    
    var happiness = 50 {
        didSet {
            happiness = min(max(happiness,0),100)
            updateUI()
    }
}
    private func updateUI(){
        faceView.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
       return Double (happiness - 50)/50
       
    }
    
    func pan (gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .Ended : fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let  happinessChange = -Int ((translation.y)/Constant.happinessPanScale)
            if happinessChange != 0 {
                happiness += happinessChange
            }
        default: break
        }
        
    }
    
    
}
