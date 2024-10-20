import SwiftUI
import RealityKit

struct ImmersiveView: View {
  @Environment(AppModel.self) var appModel
  @ObservedObject var gestureModel: HandGestureModel
  
  var body: some View {
    RealityView { content in
      content.add(createMarker(name: "origin", radius: 0.1, length: 0.5))
      content.add(createMakerForHand(name: "leftHand"))
      content.add(createMakerForHand(name: "rightHand"))
      content.add(createMakerForFinger(name: "leftIndexFinger"))
      content.add(createMakerForFinger(name: "rightIndexFinger"))
      content.add(createMakerForFinger(name: "leftMiddleFinger"))
      content.add(createMakerForFinger(name: "rightMiddleFinger"))
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
      if let transform = gestureModel.leftHandAnchorOriginFromAnchorTransform, let markerEntity = content.entities.first(where: { $0.name == "leftHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.rightHandAnchorOriginFromAnchorTransform, let markerEntity = content.entities.first(where: { $0.name == "rightHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromLeftHandIndexFingerTipTransform, let markerEntity = content.entities.first(where: { $0.name == "leftIndexFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromRightHandIndexFingerTipTransform, let markerEntity = content.entities.first(where: { $0.name == "rightIndexFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromLeftHandMiddleFingerTipTransform, let markerEntity = content.entities.first(where: { $0.name == "leftMiddleFinger" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.originFromRightHandMiddleFingerTipTransform, let markerEntity = content.entities.first(where: { $0.name == "rightMiddleFinger" }) as? ModelEntity {
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
    .persistentSystemOverlays(.hidden)
  }
  
  private func createSphere(name: String) -> ModelEntity {
    let sphereMesh = MeshResource.generateSphere(radius: 0.005)
    let material = SimpleMaterial(color: .red, isMetallic: true)
    let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
    sphereEntity.name = name
    return sphereEntity
  }
  
  private func createMakerForHand(name: String) -> ModelEntity {
    createMarker(name: name, radius: 0.005, length: 0.1)
  }
  
  private func createMakerForFinger(name: String) -> ModelEntity {
    createMarker(name: name, radius: 0.001, length: 0.03)
  }
  
  private func createMarker(name: String, radius: Float, length: Float) -> ModelEntity {
      let originEntity = ModelEntity(mesh: .generateSphere(radius: radius),
                                     materials: [SimpleMaterial(color: .white, isMetallic: false)])
      let axisLength: Float = length
      let xAxis = createAxisLine(length: axisLength, color: .red, alignment: .x)
      originEntity.addChild(xAxis)
      let yAxis = createAxisLine(length: axisLength, color: .green, alignment: .y)
      originEntity.addChild(yAxis)
      let zAxis = createAxisLine(length: axisLength, color: .blue, alignment: .z)
      originEntity.addChild(zAxis)
    originEntity.name = name
      return originEntity
  }

  private func createAxisLine(length: Float, color: UIColor, alignment: Alignment) -> ModelEntity {
      let thickness: Float = 0.003
      var size: SIMD3<Float>
      var position: SIMD3<Float>
      
      switch alignment {
      case .x:
          size = [length, thickness, thickness]
          position = [length / 2, 0, 0]
      case .y:
          size = [thickness, length, thickness]
          position = [0, length / 2, 0]
      case .z:
          size = [thickness, thickness, length]
          position = [0, 0, length / 2]
      }
      
      let axis = ModelEntity(mesh: .generateBox(size: size),
                             materials: [SimpleMaterial(color: color, isMetallic: false)])
      axis.position = position
      return axis
  }
  
  enum Alignment {
      case x, y, z
  }
}

#Preview(immersionStyle: .full) {
  ImmersiveView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
