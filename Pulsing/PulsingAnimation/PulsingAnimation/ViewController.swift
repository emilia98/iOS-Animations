//
//  ViewController.swift
//  PulsingAnimation
//
//  Created by Emilia Nedyalkova on 25.07.21.
//

import UIKit

class ViewController: UIViewController {
    private let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let center = view.center
        
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 100,
            startAngle: -CGFloat.pi / 2,
            endAngle: 2 * CGFloat.pi,
            clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "someKey")
    }


}

