import SwiftUI
import RealityKit

struct ContentView: View {
  @ObservedObject var gestureModel: HandGestureModel
  let padding = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  
  var body: some View {
    VStack() {
      Spacer()
      HStack() {
        handAnchorLogView(title: "Left", handAnchorOriginFromAnchorTransform: gestureModel.leftHandAnchorOriginFromAnchorTransform)
          .padding()
        handAnchorLogView(title: "Right", handAnchorOriginFromAnchorTransform: gestureModel.rightHandAnchorOriginFromAnchorTransform)
      }
      .padding(padding)
      Spacer()
      ToggleImmersiveSpaceButton()
      Spacer()
    }
  }
  
  func handAnchorLogView(title: String, handAnchorOriginFromAnchorTransform: simd_float4x4?) -> some View {
    VStack(alignment: .leading) {
      Text("\(title) Hand Anchor")
        .font(.title)
      if let handAnchorOriginFromAnchorTransform = handAnchorOriginFromAnchorTransform {
        Text("x: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform.columns.3.x)))")
        Text("y: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform.columns.3.y)))")
        Text("z: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform.columns.3.z)))")
      } else {
        Text("x:")
        Text("y:")
        Text("z:")
      }
    }
  }
  
  func roundUp(_ value: Float) -> Float {
    floor(value * 1000) / 1000
  }
}

#Preview(windowStyle: .automatic) {
  ContentView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
