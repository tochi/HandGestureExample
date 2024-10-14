import SwiftUI
import RealityKit

struct ImmersiveView: View {
  @Environment(AppModel.self) var appModel
  @ObservedObject var gestureModel: HandGestureModel
  
  var body: some View {
    RealityView { content in
      content.add(createMarker(name: "leftHand", radius: 0.005, length: 0.1))
      content.add(createMarker(name: "rightHand", radius: 0.005, length: 0.1))
    } update: { content in
      if let transform = gestureModel.leftHandAnchorOriginFromAnchorTransform, let markerEntity = content.entities.first(where: { $0.name == "leftHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
      }
      if let transform = gestureModel.rightHandAnchorOriginFromAnchorTransform, let markerEntity = content.entities.first(where: { $0.name == "rightHand" }) as? ModelEntity {
        markerEntity.transform = Transform(matrix: transform)
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
  
  func createMarker(name: String, radius: Float, length: Float) -> ModelEntity {
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

  func createAxisLine(length: Float, color: UIColor, alignment: Alignment) -> ModelEntity {
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
