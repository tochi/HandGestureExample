//
//  ContentView.swift
//  HandGestureExample
//
//  Created by Tomoyuki Tochihira on 2024/10/01.
//

import SwiftUI
import RealityKit

struct ContentView: View {
  @ObservedObject var gestureModel: HandGestureModel
  let padding = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      HStack() {
        handAnchorLogView(title: "Left", handAnchorOriginFromAnchorTransform: gestureModel.leftHandAnchorOriginFromAnchorTransform())
        handAnchorLogView(title: "Right", handAnchorOriginFromAnchorTransform: gestureModel.rightHandAnchorOriginFromAnchorTransform())
      }
      .padding(padding)
      Spacer()
      HStack() {
        fingerAnchorLogView(title: "Left", originFromFingerTransform: gestureModel.originFromLeftHandIndexFingerTipTransform(), fingerAnchorFromJointTransform: gestureModel.leftHandIndexFingerTipAnchorFromJointTransform())
        fingerAnchorLogView(title: "Right", originFromFingerTransform: gestureModel.originFromRightHandIndexFingerTipTransform(), fingerAnchorFromJointTransform: gestureModel.rightHandIndexFingerTipAnchorFromJointTransform())
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
      if (handAnchorOriginFromAnchorTransform != nil) {
        Text("x: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform!.columns.3.x)))")
        Text("y: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform!.columns.3.y)))")
        Text("z: \(String(describing: roundUp(handAnchorOriginFromAnchorTransform!.columns.3.z)))")
      } else {
        Text("x:")
        Text("y:")
        Text("z:")
      }
    }
  }
  
  func fingerAnchorLogView(title: String, originFromFingerTransform: simd_float4x4?, fingerAnchorFromJointTransform: simd_float4x4?) -> some View {
    VStack(alignment: .leading) {
      Text("\(title) Index Finger Tip Anchor")
        .font(.title)
      if (fingerAnchorFromJointTransform != nil) {
        Text("x: \(String(describing: roundUp(originFromFingerTransform!.columns.3.x))) (\(String(describing: roundUp(fingerAnchorFromJointTransform!.columns.3.x))))")
        Text("y: \(String(describing: roundUp(originFromFingerTransform!.columns.3.y))) (\(String(describing: roundUp(fingerAnchorFromJointTransform!.columns.3.y))))")
        Text("z: \(String(describing: roundUp(originFromFingerTransform!.columns.3.z))) (\(String(describing: roundUp(fingerAnchorFromJointTransform!.columns.3.z))))")
      } else {
        Text("x:")
        Text("y:")
        Text("z:")
      }
    }
  }
  
  private func roundUp(_ value: Float) -> Float {
    floor(value * 1000) / 1000
  }
}

#Preview(windowStyle: .automatic) {
  ContentView(gestureModel: HeartGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
