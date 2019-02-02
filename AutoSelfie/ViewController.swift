//
//  ViewController.swift
//  AutoSelfie
//
//  Created by ShuichiNagao on 2019/02/02.
//  Copyright © 2019 Shuichi Nagao. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet private weak var sceneView: ARSCNView!
    private let THRESHOLD: CGFloat = 0.7
    
    private var isSaving = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView?.delegate = self

        startFaceDetection()
    }

    private func startFaceDetection() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    private func savePhoto() {
        if isSaving { return }
        isSaving = true
        displayShutterAnimation()
        UIImageWriteToSavedPhotosAlbum(sceneView.snapshot(), nil, nil, nil)
        sceneView.session.pause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startFaceDetection()
            self?.isSaving = false
        }
    }
    
    private func displayShutterAnimation() {
        let shutterAnimation = CATransition.init()
        shutterAnimation.duration = 0.6
        shutterAnimation.timingFunction = CAMediaTimingFunction.init(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        shutterAnimation.type = CATransitionType(rawValue: "cameraIris")
        shutterAnimation.setValue("cameraIris", forKey: "cameraIris")
        
        let shutterLayer = CALayer.init()
        shutterLayer.bounds = view.bounds
        view.layer.addSublayer(shutterLayer)
        view.layer.add(shutterAnimation, forKey: "cameraIris")
    }
}

extension ViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let blendShapes = faceAnchor.blendShapes
        if let left = blendShapes[.mouthSmileLeft], let right = blendShapes[.mouthSmileRight] {
            let smileParameter = min(max(CGFloat(truncating: left), CGFloat(truncating: right))/THRESHOLD, 1.0)
            DispatchQueue.main.async { [weak self] in
                if smileParameter == 1 {
                    self?.savePhoto()
                }
            }
        }
    }
}

