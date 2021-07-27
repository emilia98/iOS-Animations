//
//  ViewController.swift
//  PulsingAnimation
//
//  Created by Emilia Nedyalkova on 25.07.21.
//

import UIKit

class ViewController: UIViewController {
    private let shapeLayer = CAShapeLayer()

    let percentageLabel: UILabel = {
       let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = view.center
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = center
        
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(
            arcCenter: .zero,
            radius: 100,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.position = center
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(tapGesture)
    }
    
    private let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    @objc private func handleTap() {
        beginDonloadingFile()
        // animateCircle()
        view.isUserInteractionEnabled = false
    }
    
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "someKey")
    }

    private func beginDonloadingFile() {
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else {
            return
        }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }

}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            // self.percentageLabel.text = "Start"
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print(percentage)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
}
