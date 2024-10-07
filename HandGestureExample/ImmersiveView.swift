//
//  ImmersiveView.swift
//  HandGestureExample
//
//  Created by Tomoyuki Tochihira on 2024/10/01.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
  @Environment(AppModel.self) var appModel
  @ObservedObject var gestureModel: HandGestureModel
  
  var body: some View {
    RealityView { content in
      let sphereMesh = MeshResource.generateSphere(radius: 0.005)
      let material = SimpleMaterial(color: .red, isMetallic: true)
      let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
      content.add(sphereEntity)
    } update: { content in
      if let rightHandFingerCenterTransform = gestureModel.rightHandFingerCenterTransform(), let sphereEntity = content.entities.first as? ModelEntity {
        sphereEntity.transform = Transform(matrix: rightHandFingerCenterTransform)
      }
    }
    .task {
      await gestureModel.start()
    }
    .task {
      await gestureModel.publishHandTrackingUpdates()
    }
    .task {
      await gestureModel.monitorSessionEvents()
    }
  }
}

#Preview(immersionStyle: .full) {
  ImmersiveView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
