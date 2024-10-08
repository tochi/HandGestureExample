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
      content.add(createMarker(name: "origin", radius: 0.1))
      content.add(createMarker(name: "leftHand", radius: 0.05))
      content.add(createMarker(name: "rightHand", radius: 0.05))
      content.add(createMarker(name: "leftIndexFinger", radius: 0.01))
      content.add(createMarker(name: "rightIndexFinger", radius: 0.01))
      content.add(createMarker(name: "leftMiddleFinger", radius: 0.01))
      content.add(createMarker(name: "rightMiddleFinger", radius: 0.01))
      content.add(createSphere(name: "leftCenter"))
      content.add(createSphere(name: "rightCenter"))
    } update: { content in
      if let markerEntity = content.entities.first(where: { $0.name == "origin" }) as? ModelEntity {
        let matrix = simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        markerEntity.transform = Transform(matrix: matrix)
      }
      if let transform = gestureModel.leftHandAnchorOriginFromAnchorTransform(), let markerEntity = content.entities.first(where: { $0.name == "leftHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.rightHandAnchorOriginFromAnchorTransform(), let markerEntity = content.entities.first(where: { $0.name == "rightHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromLeftHandIndexFingerTipTransform(), let markerEntity = content.entities.first(where: { $0.name == "leftIndexFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromRightHandIndexFingerTipTransform(), let markerEntity = content.entities.first(where: { $0.name == "rightIndexFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromLeftHandMiddleFingerTipTransform(), let markerEntity = content.entities.first(where: { $0.name == "leftMiddleFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromRightHandMiddleFingerTipTransform(), let markerEntity = content.entities.first(where: { $0.name == "rightMiddleFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.leftHandFingerCenterTransform(), let sphereEntity = content.entities.first(where: { $0.name == "leftCenter" }) as? ModelEntity {
        sphereEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.rightHandFingerCenterTransform(), let sphereEntity = content.entities.first(where: { $0.name == "rightCenter" }) as? ModelEntity {
        sphereEntity.transform = Transform(matrix: transform)
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
  func createMarker(name: String, radius: Float) -> ModelEntity {
    let sphereMesh = MeshResource.generateSphere(radius: radius)
    let material = SimpleMaterial(color: .gray, isMetallic: false)
    let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
    sphereEntity.name = name
    return sphereEntity
  }
  
  func createSphere(name: String) -> ModelEntity {
    let sphereMesh = MeshResource.generateSphere(radius: 0.005)
    let material = SimpleMaterial(color: .red, isMetallic: true)
    let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
    sphereEntity.name = name
    return sphereEntity
  }
}

#Preview(immersionStyle: .full) {
  ImmersiveView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
