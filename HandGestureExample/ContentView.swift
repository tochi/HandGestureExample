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
      HStack() {
        fingerAnchorLogView(title: "Left Index", originFromFingerTransform: gestureModel.originFromLeftHandIndexFingerTipTransform, fingerAnchorFromJointTransform: gestureModel.leftHandIndexFingerTipAnchorFromJointTransform)
          .padding()
        fingerAnchorLogView(title: "Right Index", originFromFingerTransform: gestureModel.originFromRightHandIndexFingerTipTransform, fingerAnchorFromJointTransform: gestureModel.rightHandIndexFingerTipAnchorFromJointTransform)
      }
      .padding(padding)
      Spacer()
      HStack() {
        fingerAnchorLogView(title: "Left Middle", originFromFingerTransform: gestureModel.originFromLeftHandMiddleFingerTipTransform, fingerAnchorFromJointTransform: gestureModel.leftHandMiddleFingerTipAnchorFromJointTransform)
          .padding()
        fingerAnchorLogView(title: "Right Middle", originFromFingerTransform: gestureModel.originFromRightHandMiddleFingerTipTransform, fingerAnchorFromJointTransform: gestureModel.rightHandMiddleFingerTipAnchorFromJointTransform)
      }
      .padding(padding)
      Spacer()
      HStack() {
        handDirectionView(title: "Left", xLeftSideFinger: gestureModel.originFromLeftHandMiddleFingerTipTransform?.columns.3.x, xRightSideFinger: gestureModel.originFromLeftHandIndexFingerTipTransform?.columns.3.x)
          .padding()
        handDirectionView(title: "Right", xLeftSideFinger: gestureModel.originFromRightHandIndexFingerTipTransform?.columns.3.x, xRightSideFinger: gestureModel.originFromRightHandMiddleFingerTipTransform?.columns.3.x)
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
  
  func fingerAnchorLogView(title: String, originFromFingerTransform: simd_float4x4?, fingerAnchorFromJointTransform: simd_float4x4?) -> some View {
    VStack(alignment: .leading) {
      Text("\(title) Finger Tip Anchor")
        .font(.title)
      if let originFromFingerTransform = originFromFingerTransform, let fingerAnchorFromJointTransform = fingerAnchorFromJointTransform {
        Text("x: \(String(describing: roundUp(originFromFingerTransform.columns.3.x))) (\(String(describing: roundUp(fingerAnchorFromJointTransform.columns.3.x))))")
        Text("y: \(String(describing: roundUp(originFromFingerTransform.columns.3.y))) (\(String(describing: roundUp(fingerAnchorFromJointTransform.columns.3.y))))")
        Text("z: \(String(describing: roundUp(originFromFingerTransform.columns.3.z))) (\(String(describing: roundUp(fingerAnchorFromJointTransform.columns.3.z))))")
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
  
  func handDirectionView(title: String, xLeftSideFinger: Float?, xRightSideFinger: Float?) -> some View {
    if let xLeft = xLeftSideFinger, let xRight = xRightSideFinger {
      var value = "Back"
      if (xRight < xLeft) {
        value = "Front"
      }
      return VStack(alignment: .leading) {
        Text(title)
          .font(.title)
        Text(value)
      }
    } else {
      return VStack(alignment: .leading) {
        Text(title)
          .font(.title)
        Text("None")
      }
    }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
