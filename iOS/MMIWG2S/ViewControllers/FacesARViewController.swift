//
//  FacesARViewController.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 10/25/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit
import ARKit

class FacesARViewController: UIViewController {
    
    private let faceNodeName = "faceNode"
    private let faceViewer = ARFaceViewerUI()
    
    private var sceneView: ARSCNView = ARSCNView()
    private var currentFaceAnchor: ARFaceAnchor?

    private var configuration: ARFaceTrackingConfiguration {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        addSceneToView(sceneView)
        setupFaceViewer()
        faceViewer.setupShareButton()
        faceViewer.setupColorToggle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // prevent auto screen dimming
        UIApplication.shared.isIdleTimerDisabled = true
        
        resetTracking()
    }
    
    private func addSceneToView(_ sceneView: ARSCNView) {
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /// Setup the ui used during the face session
    private func setupFaceViewer() {
        faceViewer.delegate = self
        
        view.addSubview(faceViewer)
        faceViewer.translatesAutoresizingMaskIntoConstraints = false
        faceViewer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        faceViewer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        faceViewer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        faceViewer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

// MARK: - ARFaceViewerUIDelegate

extension FacesARViewController: ARFaceViewerUIDelegate {
    
    func textureChanged(toRed: Bool) {
        guard let contentNode = sceneView.scene.rootNode.childNode(withName: faceNodeName, recursively: true) else { return }
        if toRed {
            contentNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "Face.scnassets/red_hand_full_mouth.png")
        } else {
            contentNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "Face.scnassets/black_hand_80_texture.png")
        }
    }
    
    func generateShareImage() -> UIImage? {
        let image = sceneView.snapshot()
        sceneView.session.pause()
        return image
    }
    
    func resumeSessionOnceCaptured() {
        resetTracking()
    }
    
}

// MARK: - ARSessionDelegate

extension FacesARViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async { [weak self] in
            self?.displayError(.errorARSessionTitle, message: errorMessage, completion: self?.resetTracking)
        }
    }
    
}

extension FacesARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        
        if node.childNodes.isEmpty,
           let device = sceneView.device,
           let faceGeometry = ARSCNFaceGeometry(device: device),
           let material = faceGeometry.firstMaterial {
            
            material.diffuse.contents = UIImage(named: "Face.scnassets/red_hand_full_mouth.png")
            material.lightingModel = .physicallyBased
            
            let contentNode = SCNNode(geometry: faceGeometry)
            contentNode.name = faceNodeName
            node.addChildNode(contentNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor == currentFaceAnchor,
              let contentNode = sceneView.scene.rootNode.childNode(withName: faceNodeName, recursively: true),
              contentNode.parent == node,
              let faceGeometry = contentNode.geometry as? ARSCNFaceGeometry,
              let faceAnchor = anchor as? ARFaceAnchor
              else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
}


