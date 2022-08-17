//
//  ViewController.swift
//  BeginnerAR
//
//  Created by Jayvenn on 2022-06-09.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
  @IBOutlet var arView: ARView!
  private let faceTrackingConfiguration: ARFaceTrackingConfiguration = {
    let faceTrackingConfiguration = ARFaceTrackingConfiguration()
    faceTrackingConfiguration.isLightEstimationEnabled = true
    return faceTrackingConfiguration
  }()
  private let hat: Entity
  // MARK: - Initializers
  required init?(coder: NSCoder) {
    guard let hat = try? Entity.load(named: "Experience") else {
      fatalError("Unable to load completely load Experience.loadHat components.")
    }
    self.hat = hat
    super.init(coder: coder)
  }
  // MARK: - View Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    arView.session.delegate = self
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    resetTrackingConfiguration()
  }
  private func resetTrackingConfiguration() {
    arView.session.run(
      faceTrackingConfiguration,
      options: [.removeExistingAnchors, .resetTracking]
    )
  }
}

// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {
  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    for case let faceAnchor as ARFaceAnchor in anchors {
      let anchorEntity = AnchorEntity(anchor: faceAnchor)
      anchorEntity.addChild(hat)
      arView.scene.addAnchor(anchorEntity)
    }
  }
  
}
